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
#   - Shell: /bin/sh
#   - Script:
#       "${BUILD_DIR%Build/*}SourcePackages/checkouts/firebase-ios-sdk-xcframeworks/.scripts/resources.sh"
#   - Make sure it runs AFTER "Copy Bundle Resources".
#   - Uncheck "Based on dependency analysis" so it runs every build.
#
# Reference: https://github.com/akaffenberger/firebase-ios-sdk-xcframeworks/issues/23
# ══════════════════════════════════════════════════════════════════════════════

set -eu

# Directory of the main app bundle being built.
BUILD_APP_DIR="${BUILT_PRODUCTS_DIR}/${FULL_PRODUCT_NAME}"

# Resolve to the directory this script lives in (…/firebase-ios-sdk-xcframeworks/.scripts).
cd "${0%/*}"

# Skip the loop cleanly if no resources exist.
shopt -s nullglob

copied=0
for resource in ../Sources/*/Resources/*.*; do (
    file=$(basename "$resource")
    cp -R "$resource" "$BUILD_APP_DIR/$file"
    echo "note: Firebase resources: copied $file → $BUILD_APP_DIR/"
) & done
wait

echo "note: Firebase resources: done."
