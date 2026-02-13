# Firebase iOS SDK — Pre-built XCFrameworks for SPM

![Release](https://img.shields.io/github/v/release/bogdanmatasaru/firebase-ios-sdk-xcframeworks?label=Firebase&color=orange)
![Workflow](https://img.shields.io/github/actions/workflow/status/bogdanmatasaru/firebase-ios-sdk-xcframeworks/package.yml?label=Auto-update)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20tvOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20visionOS-blue)

Pre-built Firebase iOS SDK XCFrameworks distributed via Swift Package Manager `binaryTarget`.

XCFrameworks are **downloaded directly from Google's official Firebase release** — they are never compiled by this repository. The packaging script only repackages them individually for SPM consumption.

## Why

Firebase iOS SDK contains hundreds of thousands of lines of code. Compiling from source adds **3–10 minutes** to every clean build. Pre-built binaries eliminate this entirely — SPM downloads them in seconds.

## Installation

Add the package to your project:

```swift
dependencies: [
    .package(
        url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks.git",
        exact: "12.9.0"  // Pin to exact Firebase version
    ),
]
```

Then add only the products you need:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk-xcframeworks"),
        .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk-xcframeworks"),
        .product(name: "FirebaseMessaging", package: "firebase-ios-sdk-xcframeworks"),
    ]
)
```

> **Important:** Add `-ObjC` to Build Settings → Other Linker Flags.

## Available Products

All Firebase products from the official release are available:

| Product | Description |
|---------|-------------|
| `FirebaseAnalytics` | Event tracking, user properties, conversions |
| `FirebaseAuth` | Email/password, phone, and federated sign-in |
| `FirebaseCrashlytics` | Crash reporting and error logging |
| `FirebaseDatabase` | Realtime NoSQL database |
| `FirebaseFirestore` | Cloud Firestore document database |
| `FirebaseFunctions` | Cloud Functions client |
| `FirebaseInAppMessaging` | In-app messaging campaigns |
| `FirebaseMessaging` | Push notifications (APNs) |
| `FirebasePerformance` | Automatic performance monitoring |
| `FirebaseRemoteConfig` | Server-side configuration |
| `FirebaseStorage` | Cloud Storage file upload/download |
| `GoogleSignIn` | OAuth 2.0 authentication via Google |
| And more... | All products from the official Firebase ZIP |

## How It Works

A daily [GitHub Actions workflow](.github/workflows/package.yml):

1. Checks if a new **stable** Firebase release exists (pre-releases are excluded)
2. Downloads the official `Firebase.zip` from Google's release
3. Extracts and repackages each `.xcframework` individually
4. Generates `Package.swift` with `binaryTarget` entries and SHA256 checksums
5. Creates a tagged GitHub release with all assets
6. Verifies the asset count matches expectations

### Version Tracking

- **Automatic:** The workflow runs daily at midnight UTC
- **Manual:** Trigger from the Actions tab with an optional version override
- **Concurrency safe:** Overlapping runs are automatically cancelled

## Running Locally

```bash
# Prerequisites
brew install gh
gh auth login

# Generate files locally (no release)
cd .scripts && sh package.sh debug skip-release

# Force a specific version
FIREBASE_VERSION=12.9.0 sh package.sh debug skip-release
```

## Security

- XCFrameworks are **never compiled** by this repository
- All binaries come from [Google's official GitHub release](https://github.com/firebase/firebase-ios-sdk/releases)
- SHA256 checksums are computed for every `.xcframework.zip` and embedded in `Package.swift`
- SPM verifies checksums on download — any tampering is detected automatically

## License

- Firebase SDK: [Apache 2.0](https://github.com/firebase/firebase-ios-sdk/blob/main/LICENSE)
- This packaging script: [MIT](LICENSE)
