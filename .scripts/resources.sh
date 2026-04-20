#!/bin/bash
# ══════════════════════════════════════════════════════════════════════════════
# Firebase XCFrameworks — Resource Bundle Copy Helper
#
# Firebase ships a few resource bundles alongside its xcframeworks:
#   - GoogleMobileAdsSDK.bundle
#   - gRPCCertificates-Cpp.bundle
#   - …and a handful of .plist / .xcprivacy files per library.
#
# If these are declared as `.process(…)` / `.copy(…)` in Package.swift, SPM
# puts them into a per-target resource bundle instead of the main app bundle.
# Firebase at runtime looks for them in the MAIN BUNDLE (Bundle.main.path(forResource:))
# and cannot find them → silent misconfig (no ads, no TLS for Firestore, etc.).
#
# Workaround (Apple-recommended for binaryTarget + resources):
#   1. Package.swift declares these files in `exclude:` so they are NOT built
#      into a resource bundle.
#   2. The consumer adds this script as a "Run Script Phase" in their app
#      target's Build Phases — it copies the resources directly into .app/.
#
# HOW TO USE (in your consumer Xcode project):
#   - Target → Build Phases → + → New Run Script Phase
#   - Shell: /bin/bash   (REQUIRED — script uses `shopt`, a bash builtin)
#   - Script:
#       "${BUILD_DIR%Build/*}SourcePackages/checkouts/firebase-ios-sdk-xcframeworks/.scripts/resources.sh"
#   - Make sure it runs AFTER "Copy Bundle Resources".
#   - Uncheck "Based on dependency analysis" so it runs every build.
#
# Reference: https://github.com/akaffenberger/firebase-ios-sdk-xcframeworks/issues/23
# ══════════════════════════════════════════════════════════════════════════════

# Strict mode: exit on unset var, command failure, OR any failure in a pipeline.
# `pipefail` matters here because we fan out `cp` calls and aggregate via `wait`.
set -euo pipefail

# Directory of the main app bundle being built (provided by Xcode).
BUILD_APP_DIR="${BUILT_PRODUCTS_DIR}/${FULL_PRODUCT_NAME}"

# Resolve to the directory this script lives in (…/firebase-ios-sdk-xcframeworks/.scripts).
cd "${0%/*}"

# Skip the loop cleanly if no resources exist (bash builtin → /bin/sh will error).
shopt -s nullglob

# Capture PIDs so `wait <pid>` can propagate per-job exit codes. Plain `wait`
# (no args) in bash returns 0 whenever *any* child succeeded, which would hide
# a failed `cp`. Tracking PIDs gives us true fail-fast semantics.
pids=()
for resource in ../Sources/*/Resources/*.*; do
    (
        file=$(basename "$resource")
        cp -R "$resource" "$BUILD_APP_DIR/$file"
        echo "note: Firebase resources: copied $file → $BUILD_APP_DIR/"
    ) &
    pids+=("$!")
done

# Wait on each child individually; first failure aborts the whole script.
# Guard against empty array: `"${pids[@]}"` with `set -u` errors on
# pre-4.4 bash when the array has no elements, which is the common case when
# the script runs against a build without any Firebase resources.
if [[ "${#pids[@]}" -gt 0 ]]; then
    for pid in "${pids[@]}"; do
        if ! wait "$pid"; then
            echo "error: Firebase resources: copy job (pid=$pid) failed" >&2
            exit 1
        fi
    done
fi

echo "note: Firebase resources: done (${#pids[@]} file(s) copied)."
