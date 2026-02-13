#!/bin/bash
# ══════════════════════════════════════════════════════════════════════════════
# Firebase iOS SDK XCFrameworks — Automated Packaging Script
#
# Mirrors official Firebase iOS SDK releases as pre-built XCFrameworks
# distributed via Swift Package Manager binary targets.
#
# Flow:
#   1. Compare upstream Firebase version with latest local release
#   2. Download official Firebase.zip from Google's GitHub release
#   3. Extract & repackage each .xcframework individually (with _ prefix)
#   4. Generate Package.swift with binaryTarget entries + SHA256 checksums
#   5. Create a tagged GitHub release with all .xcframework.zip assets
#   6. Verify the release asset count matches expectations
#
# The XCFrameworks are NEVER compiled — they come directly from Google's
# official release artifacts. This script only repackages them for SPM.
#
# Usage:
#   cd .scripts && sh package.sh                    # Full automated release
#   cd .scripts && sh package.sh debug              # Debug (opens temp dir)
#   cd .scripts && sh package.sh debug skip-release # Generate locally only
#
# Environment:
#   FIREBASE_VERSION  — Force a specific version (skips latest check)
# ══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# ── Configuration ─────────────────────────────────────────────────────────

readonly FIREBASE_REPO="https://github.com/firebase/firebase-ios-sdk"
readonly XCFRAMEWORKS_REPO="https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Logging ───────────────────────────────────────────────────────────────

log()   { echo "[INFO]  $*"; }
warn()  { echo "[WARN]  $*" >&2; }
error() { echo "[ERROR] $*" >&2; exit 1; }
step()  { echo ""; echo "[$1/$TOTAL_STEPS] $2"; }

TOTAL_STEPS=6

# ── Helper Functions ──────────────────────────────────────────────────────

latest_stable_release() {
    # Get the latest NON-pre-release version from a GitHub repo.
    # Uses --exclude-pre-releases to avoid betas/RCs.
    gh release list --repo "$1" --exclude-pre-releases --limit 1 \
        | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' \
        | head -1 || echo "0.0.0"
}

xcframework_name() {
    # Extract framework name from path.
    # e.g. "FirebaseFirestore/leveldb-library.xcframework" → "leveldb-library"
    echo "$1" | sed -E 's/.*\/|\.xcframework(\.zip)?//g'
}

library_name() {
    # Extract library folder name from path.
    # e.g. "FirebaseAnalytics/FirebaseInstallations.xcframework" → "FirebaseAnalytics"
    echo "$1" | sed -E 's/\/.*//g'
}

non_xcframework_files() {
    # Return files that are NOT xcframeworks (resources, plists, etc.)
    echo "$1" | grep -v -E "\.xcframework"
}

trim_empty_lines() {
    sed -i '' '/^$/d' "$1"
}

template_replace() {
    local file_content
    file_content=$(cat "$1")
    trim_empty_lines "$3"
    local replacement
    replacement=$(cat "$3")
    # Replace placeholder with generated content
    local result="${file_content//"$2"/"$replacement"}"
    printf "%s" "$result" > "$1"
}

# ── Scratch Directory ─────────────────────────────────────────────────────

create_scratch() {
    scratch=$(mktemp -d -t FirebasePackaging)
    if [[ ${debug:-} ]]; then open "$scratch"; fi
    trap 'if [[ ${debug:-} ]]; then read -r -p "Press enter to clean up..."; fi; rm -rf "$scratch"' EXIT
}

# ── Framework Processing ─────────────────────────────────────────────────

rename_frameworks_with_prefix() {
    local prefix="$1"
    for framework in */*.xcframework; do (
        local name
        name=$(xcframework_name "$framework")
        cd "$framework/../"
        mv "$name.xcframework" "${prefix}${name}.xcframework"
    ) & done
    wait
}

zip_frameworks() {
    for framework in */*.xcframework; do (
        local name
        name=$(xcframework_name "$framework")
        cd "$framework/../"
        # -y preserves symlinks, -q quiet, -o update only
        zip -ryqo "$name.xcframework.zip" "$name.xcframework"
    ) & done
    wait
}

prepare_distribution() {
    local dist="$1"
    mkdir -p "$dist"
    # Unzipped frameworks (for local Package.swift testing)
    for framework in */*.xcframework; do cp -rf "$framework" "$dist"; done
    # Zipped frameworks (for GitHub release upload)
    for archive in */*.xcframework.zip; do cp -f "$archive" "$dist"; done
}

# ── Source Generation ─────────────────────────────────────────────────────

generate_sources() {
    local sources="$1"
    mkdir -p "$sources/Firebase"

    # Umbrella header and modulemap (from the official Firebase.zip)
    cp -f "Firebase.h" "$sources/Firebase/"
    cp -f "module.modulemap" "$sources/Firebase/"
    touch "$sources/Firebase/dummy.m"  # SPM requires at least one source file

    # Per-library source directories with dummy files
    for lib_dir in */; do
        local name
        name=$(library_name "$lib_dir")
        mkdir -p "$sources/$name"
        touch "$sources/$name/dummy.swift"

        # Copy resources if present
        if [[ -d "$lib_dir/Resources" ]]; then
            cp -rf "$lib_dir/Resources" "$sources/$name/"
        fi

        # Copy non-xcframework files (plists, configs, etc.)
        for file in "${lib_dir}"*; do
            if [[ $(non_xcframework_files "$file") ]]; then
                if [[ -d "$file" ]]; then
                    cp -rf "$file" "$sources/$name/"
                else
                    cp -f "$file" "$sources/$name/"
                fi
            fi
        done
    done
}

# ── Package.swift Generation ─────────────────────────────────────────────

detect_platforms() {
    # Detect which platforms an xcframework supports.
    # Returns a conditional dependency string if not all platforms are supported.
    local name
    name=$(xcframework_name "$1")

    local platforms=()
    ls "$name.xcframework" | grep -q "ios-"     && platforms+=(".iOS")
    ls "$name.xcframework" | grep -q "tvos-"    && platforms+=(".tvOS")
    ls "$name.xcframework" | grep -q "macos-"   && platforms+=(".macOS")
    ls "$name.xcframework" | grep -q "watchos-"  && platforms+=(".watchOS")
    ls "$name.xcframework" | grep -q "xros-"    && platforms+=(".visionOS")

    local joined
    joined=$(IFS=", "; echo "${platforms[*]}")

    if [[ "$joined" == ".iOS, .tvOS, .macOS" || "$joined" == ".iOS, .tvOS, .macOS, .watchOS, .visionOS" ]]; then
        # Supports all major platforms — no condition needed
        echo "\"$name\""
    else
        echo ".target(name: \"$name\", condition: .when(platforms: [$joined]))"
    fi
}

write_library() {
    local library
    library=$(library_name "$1")
    local output="$2"
    local comma="${3:-}"

    printf "%s\n        .library(\n            name: \"%s\",\n            targets: [\"%sTarget\"]\n        )" \
        "$comma" "$library" "$library" >> "$output"
}

write_target() {
    local library
    library=$(library_name "$1")
    local output="$2"
    local comma="${3:-}"
    local target="${library}Target"
    local dependencies
    dependencies=$(ls -1A "$library" | grep ".xcframework.zip" || true)
    local excludes
    excludes=$(non_xcframework_files "$(ls -1A "$library")" || true)

    printf "%s\n        .target(\n            name: \"%s\",\n            dependencies: [\n                \"Firebase\"" \
        "$comma" "$target" >> "$output"

    # All targets depend on FirebaseAnalytics core binaries
    if [[ "$target" != "FirebaseAnalyticsTarget" ]]; then
        printf ",\n                \"FirebaseAnalyticsTarget\"" >> "$output"
    fi

    # Library-specific xcframework dependencies
    if [[ -n "$dependencies" ]]; then
        echo "$dependencies" | while read -r dep; do
            printf ",\n                %s" "$(cd "$library"; detect_platforms "$dep")" >> "$output"
        done
    fi
    printf "\n            ]" >> "$output"

    # Source path
    printf ",\n            path: \"Sources/%s\"" "$library" >> "$output"

    # Excluded non-xcframework files
    if [[ -n "$excludes" ]]; then
        printf ",\n            exclude: [" >> "$output"
        local exc_comma=""
        echo "$excludes" | while read -r exc; do
            printf "%s\n                \"%s\"" "$exc_comma" "$exc" >> "$output"
            exc_comma=","
        done
        printf "\n            ]" >> "$output"
    fi

    printf "\n        )" >> "$output"
}

write_binary_target() {
    local file="$1"
    local repo="$2"
    local version="$3"
    local output="$4"
    local comma="${5:-}"

    touch Package.swift  # checksum command requires a package manifest
    local checksum
    checksum=$(swift package compute-checksum "$file")
    local name
    name=$(xcframework_name "$file")

    printf "%s\n        .binaryTarget(\n            name: \"%s\",\n            url: \"%s/releases/download/%s/%s.xcframework.zip\",\n            checksum: \"%s\"\n        )" \
        "$comma" "$name" "$repo" "$version" "$name" "$checksum" >> "$output"
}

write_local_binary_target() {
    local name
    name=$(xcframework_name "$1")
    local dist="$2"
    local output="$3"
    local comma="${4:-}"

    printf "%s\n        .binaryTarget(\n            name: \"%s\",\n            path: \"%s/%s.xcframework\"\n        )" \
        "$comma" "$name" "$dist" "$name" >> "$output"
}

generate_swift_package() {
    local package="$1"
    local template="$2"
    local dist="$3"
    local repo="$4"
    local local_dist="${5:-}"
    local libraries_file="libraries.txt"
    local targets_file="targets.txt"
    local binaries_file="binaries.txt"

    cp -f "$template" "$package"

    # Generate library products
    local comma=""
    for lib_dir in */; do
        write_library "$lib_dir" "$libraries_file" "$comma"
        comma=","
    done

    # Generate target definitions
    comma=""
    for lib_dir in */; do
        write_target "$lib_dir" "$targets_file" "$comma"
        comma=","
    done

    # Generate binary targets
    # NOTE: comma starts as "," to separate from the last .target() entry above
    if [[ -n "$local_dist" ]]; then
        log "Generating local Package.swift for testing..."
        comma=","
        for framework in "$dist"/*.xcframework; do
            write_local_binary_target "$framework" "$local_dist" "$binaries_file" "$comma"
            comma=","
        done
    else
        log "Generating release Package.swift..."
        comma=","
        for archive in "$dist"/*.xcframework.zip; do
            write_binary_target "$archive" "$repo" "$latest" "$binaries_file" "$comma"
            comma=","
        done
    fi

    # Replace template placeholders with generated content
    template_replace "$package" "// GENERATE LIBRARIES" "$libraries_file"; rm -f "$libraries_file"
    template_replace "$package" "// GENERATE TARGETS" "$targets_file"; rm -f "$targets_file"
    template_replace "$package" "// GENERATE BINARIES" "$binaries_file"; rm -f "$binaries_file"
}

# ── Git & Release ─────────────────────────────────────────────────────────

commit_and_push() {
    local version="$1"
    git add .
    git commit -m "Release $version — updated Package.swift and sources"
    git push origin main
}

create_github_release() {
    local version="$1"
    local assets_dir="$2"

    # Create tag if it doesn't exist
    if git rev-parse "$version" >/dev/null 2>&1; then
        warn "Tag $version already exists, skipping tag creation."
    else
        log "Creating tag $version..."
        git tag "$version"
        git push origin "$version"
    fi

    log "Creating GitHub release with xcframework assets..."
    gh release create "$version" \
        --target "main" \
        --title "Firebase iOS SDK $version" \
        --notes "Pre-built XCFrameworks from the official Firebase iOS SDK $version release.

**Source:** [firebase/firebase-ios-sdk $version](https://github.com/firebase/firebase-ios-sdk/releases/tag/$version)
**Release notes:** [Firebase iOS Release Notes](https://firebase.google.com/support/release-notes/ios)" \
        "$assets_dir"/*.xcframework.zip
}

verify_release_assets() {
    local version="$1"
    local expected_dir="$2"

    local expected
    expected=$(find "$expected_dir" -name "*.xcframework.zip" | wc -l | tr -d ' ')
    local actual
    actual=$(gh release view "$version" --json assets --jq '.assets | length')

    if [[ "$expected" -ne "$actual" ]]; then
        error "Asset count mismatch: expected $expected, got $actual. Release may be incomplete."
    fi
    log "Release verified: $actual assets uploaded successfully."
}

# ══════════════════════════════════════════════════════════════════════════
# Main
# ══════════════════════════════════════════════════════════════════════════

# Parse arguments
debug=$(echo "${*:-}" | grep -o "debug" || true)
skip_release=$(echo "${*:-}" | grep -o "skip-release" || true)

# Determine versions
if [[ -n "${FIREBASE_VERSION:-}" ]]; then
    latest="$FIREBASE_VERSION"
    log "Using forced version: $latest"
else
    latest=$(latest_stable_release "$FIREBASE_REPO")
fi
current=$(latest_stable_release "$XCFRAMEWORKS_REPO")

echo "======================================================================"
echo "  Firebase XCFrameworks Packager"
echo "======================================================================"
echo "  Upstream (firebase-ios-sdk):  $latest"
echo "  Current  (this repo):         $current"
echo "======================================================================"

if [[ "$latest" == "$current" && -z "${debug:-}" ]]; then
    log "$current is up to date. Nothing to do."
    exit 0
fi

log "Updating from $current → $latest..."

distribution="dist"
sources="Sources"
package="Package.swift"

create_scratch
(
    cd "$scratch"
    home="$OLDPWD"

    step 1 "Downloading Firebase $latest from Google..."
    gh release download --pattern 'Firebase.zip' --repo "$FIREBASE_REPO" --clobber

    # Extract the Firebase.zip
    zip_file=$(find . -name "*.zip" -maxdepth 1 | head -1)
    if [[ -z "$zip_file" ]]; then error "Firebase.zip download failed."; fi
    log "Extracting $zip_file..."
    unzip -q "$zip_file"

    # Handle nested zip structures (some releases wrap in an extra folder)
    if [[ ! -d "Firebase" ]]; then
        for dir in */; do
            if [[ -d "$dir" && "$dir" != "carthage/" ]]; then
                nested_zip=$(find "$dir" -name "Firebase*.zip" -maxdepth 1 | head -1)
                if [[ -n "$nested_zip" ]]; then
                    log "Found nested archive: $nested_zip"
                    unzip -q "$nested_zip"
                    break
                fi
            fi
        done
        [[ -d "Firebase" ]] || error "Firebase directory not found after extraction."
    fi

    step 2 "Preparing xcframeworks for distribution..."
    cd Firebase
    rename_frameworks_with_prefix "_"
    zip_frameworks

    step 3 "Creating distribution files..."
    prepare_distribution "../$distribution"

    step 4 "Generating source files..."
    generate_sources "../$sources"

    step 5 "Generating & validating Package.swift (local)..."
    generate_swift_package "../$package" "$home/package_template.swift" "../$distribution" "$XCFRAMEWORKS_REPO" "$distribution"
    log "Validating local manifest..."
    (cd ..; swift package dump-package > /dev/null)

    step 6 "Generating & validating Package.swift (release)..."
    generate_swift_package "../$package" "$home/package_template.swift" "../$distribution" "$XCFRAMEWORKS_REPO" ""
    log "Validating release manifest..."
    (cd ..; swift package dump-package > /dev/null)
)

log "Moving generated files to repo..."
cd ..

# Clean existing generated files
[[ -d "$sources" ]] && rm -rf "$sources"
[[ -f "$package" ]] && rm -f "$package"

# Move generated files into repo
mv "$scratch/$sources" "$sources"
mv "$scratch/$package" "$package"

# Skip deploy if requested
if [[ -n "${skip_release:-}" ]]; then
    log "Done (skip-release mode). Files generated locally."
    exit 0
fi

# Deploy
log "Pushing changes to GitHub..."
commit_and_push "$latest"

log "Creating GitHub release..."
create_github_release "$latest" "$scratch/dist"

log "Verifying release..."
verify_release_assets "$latest" "$scratch/dist"

echo ""
echo "======================================================================"
echo "  DONE — Firebase $latest published successfully"
echo "  Assets: $(find "$scratch/dist" -name '*.xcframework.zip' | wc -l | tr -d ' ') xcframeworks"
echo "======================================================================"
