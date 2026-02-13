# Firebase iOS SDK — Pre-built XCFrameworks for SPM

Pre-built Firebase iOS SDK XCFrameworks distributed via Swift Package Manager `binaryTarget`.

XCFrameworks are **downloaded directly from Google's official Firebase release** — they are never compiled by this repository. The script only repackages them individually for SPM consumption.

## Why

Firebase iOS SDK contains hundreds of thousands of lines of code (especially C++ in Firestore/gRPC). Compiling from source adds 3–10 minutes to clean builds. Pre-built binaries eliminate this entirely.

## Installation

Add the package to your project:

```swift
dependencies: [
    .package(
        url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks.git",
        exact: "12.9.0"
    ),
]
```

Then add the products you need:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk-xcframeworks"),
        .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk-xcframeworks"),
        .product(name: "FirebaseMessaging", package: "firebase-ios-sdk-xcframeworks"),
        // ... add only what you need
    ]
)
```

Add `-ObjC` to Build Settings → Other Linker Flags.

## Available Products

All Firebase products from the official release are available:

- FirebaseAnalytics
- FirebaseAuth
- FirebaseCrashlytics
- FirebaseDatabase
- FirebaseFirestore
- FirebaseFunctions
- FirebaseInAppMessaging
- FirebaseMessaging
- FirebaseMLModelDownloader
- FirebasePerformance
- FirebaseRemoteConfig
- FirebaseStorage
- GoogleSignIn
- And more...

## How It Works

A daily GitHub Actions workflow:

1. Checks if a new Firebase release exists on [firebase/firebase-ios-sdk](https://github.com/firebase/firebase-ios-sdk)
2. Downloads the official `Firebase.zip` from Google's release
3. Extracts and repackages each `.xcframework` individually
4. Generates `Package.swift` with `binaryTarget` entries and SHA256 checksums
5. Creates a tagged GitHub release with all assets

## Running Locally

```bash
brew install gh
gh auth login
cd .scripts && sh package.sh debug skip-release
```

## License

- Firebase SDK: [Apache 2.0](https://github.com/firebase/firebase-ios-sdk/blob/main/LICENSE)
- This packaging script: [MIT](LICENSE)
