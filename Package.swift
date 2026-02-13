// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Firebase",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v7)],
    products: [
                .library(
            name: "FirebaseABTesting",
            targets: ["FirebaseABTestingTarget"]
        ),
        .library(
            name: "FirebaseAILogic",
            targets: ["FirebaseAILogicTarget"]
        ),
        .library(
            name: "FirebaseAnalytics",
            targets: ["FirebaseAnalyticsTarget"]
        ),
        .library(
            name: "FirebaseAppCheck",
            targets: ["FirebaseAppCheckTarget"]
        ),
        .library(
            name: "FirebaseAppDistribution",
            targets: ["FirebaseAppDistributionTarget"]
        ),
        .library(
            name: "FirebaseAuth",
            targets: ["FirebaseAuthTarget"]
        ),
        .library(
            name: "FirebaseCrashlytics",
            targets: ["FirebaseCrashlyticsTarget"]
        ),
        .library(
            name: "FirebaseDatabase",
            targets: ["FirebaseDatabaseTarget"]
        ),
        .library(
            name: "FirebaseFirestore",
            targets: ["FirebaseFirestoreTarget"]
        ),
        .library(
            name: "FirebaseFunctions",
            targets: ["FirebaseFunctionsTarget"]
        ),
        .library(
            name: "FirebaseInAppMessaging",
            targets: ["FirebaseInAppMessagingTarget"]
        ),
        .library(
            name: "FirebaseMessaging",
            targets: ["FirebaseMessagingTarget"]
        ),
        .library(
            name: "FirebaseMLModelDownloader",
            targets: ["FirebaseMLModelDownloaderTarget"]
        ),
        .library(
            name: "FirebasePerformance",
            targets: ["FirebasePerformanceTarget"]
        ),
        .library(
            name: "FirebaseRemoteConfig",
            targets: ["FirebaseRemoteConfigTarget"]
        ),
        .library(
            name: "FirebaseStorage",
            targets: ["FirebaseStorageTarget"]
        ),
        .library(
            name: "GoogleSignIn",
            targets: ["GoogleSignInTarget"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Firebase",
            publicHeadersPath: "./"
        ),
                .target(
            name: "FirebaseABTestingTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_FirebaseABTesting"
            ],
            path: "Sources/FirebaseABTesting"
        ),
        .target(
            name: "FirebaseAILogicTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_FirebaseAILogic",
                "_FirebaseAppCheckInterop",
                "_FirebaseAuthInterop",
                "_FirebaseCoreExtension"
            ],
            path: "Sources/FirebaseAILogic"
        ),
        .target(
            name: "FirebaseAnalyticsTarget",
            dependencies: [
                "Firebase",
                "_FBLPromises",
                "_FirebaseAnalytics",
                "_FirebaseCore",
                "_FirebaseCoreInternal",
                "_FirebaseInstallations",
                .target(name: "_GoogleAdsOnDeviceConversion", condition: .when(platforms: [.iOS])),
                "_GoogleAppMeasurement",
                "_GoogleAppMeasurementIdentitySupport",
                "_GoogleUtilities",
                "_nanopb"
            ],
            path: "Sources/FirebaseAnalytics"
        ),
        .target(
            name: "FirebaseAppCheckTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_AppCheckCore",
                "_FirebaseAppCheck",
                "_FirebaseAppCheckInterop"
            ],
            path: "Sources/FirebaseAppCheck"
        ),
        .target(
            name: "FirebaseAppDistributionTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                .target(name: "_FirebaseAppDistribution", condition: .when(platforms: [.iOS]))
            ],
            path: "Sources/FirebaseAppDistribution"
        ),
        .target(
            name: "FirebaseAuthTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_FirebaseAppCheckInterop",
                "_FirebaseAuth",
                "_FirebaseAuthInterop",
                "_FirebaseCoreExtension",
                "_GTMSessionFetcher",
                .target(name: "_RecaptchaInterop", condition: .when(platforms: [.iOS]))
            ],
            path: "Sources/FirebaseAuth"
        ),
        .target(
            name: "FirebaseCrashlyticsTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_FirebaseCoreExtension",
                "_FirebaseCrashlytics",
                "_FirebaseRemoteConfigInterop",
                "_FirebaseSessions",
                "_GoogleDataTransport",
                "_Promises"
            ],
            path: "Sources/FirebaseCrashlytics",
            exclude: [
                "run",
                "upload-symbols"
            ]
        ),
        .target(
            name: "FirebaseDatabaseTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_FirebaseAppCheckInterop",
                "_FirebaseDatabase",
                "_FirebaseSharedSwift",
                "_leveldb"
            ],
            path: "Sources/FirebaseDatabase"
        ),
        .target(
            name: "FirebaseFirestoreTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_absl",
                "_FirebaseAppCheckInterop",
                "_FirebaseCoreExtension",
                "_FirebaseFirestore",
                "_FirebaseFirestoreInternal",
                "_FirebaseSharedSwift",
                "_grpc",
                "_grpcpp",
                "_leveldb",
                "_openssl_grpc"
            ],
            path: "Sources/FirebaseFirestore"
        ),
        .target(
            name: "FirebaseFunctionsTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_FirebaseAppCheckInterop",
                "_FirebaseAuthInterop",
                "_FirebaseCoreExtension",
                "_FirebaseFunctions",
                "_FirebaseMessagingInterop",
                "_FirebaseSharedSwift",
                "_GTMSessionFetcher"
            ],
            path: "Sources/FirebaseFunctions"
        ),
        .target(
            name: "FirebaseInAppMessagingTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_FirebaseABTesting",
                .target(name: "_FirebaseInAppMessaging", condition: .when(platforms: [.iOS]))
            ],
            path: "Sources/FirebaseInAppMessaging"
        ),
        .target(
            name: "FirebaseMessagingTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_FirebaseMessaging",
                "_GoogleDataTransport"
            ],
            path: "Sources/FirebaseMessaging"
        ),
        .target(
            name: "FirebaseMLModelDownloaderTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_FirebaseCoreExtension",
                "_FirebaseMLModelDownloader"
            ],
            path: "Sources/FirebaseMLModelDownloader"
        ),
        .target(
            name: "FirebasePerformanceTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_FirebaseABTesting",
                "_FirebaseCoreExtension",
                .target(name: "_FirebasePerformance", condition: .when(platforms: [.iOS, .tvOS])),
                "_FirebaseRemoteConfig",
                "_FirebaseRemoteConfigInterop",
                "_FirebaseSessions",
                "_FirebaseSharedSwift",
                "_GoogleDataTransport",
                "_Promises"
            ],
            path: "Sources/FirebasePerformance"
        ),
        .target(
            name: "FirebaseRemoteConfigTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_FirebaseABTesting",
                "_FirebaseRemoteConfig",
                "_FirebaseRemoteConfigInterop",
                "_FirebaseSharedSwift"
            ],
            path: "Sources/FirebaseRemoteConfig"
        ),
        .target(
            name: "FirebaseStorageTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "_FirebaseAppCheckInterop",
                "_FirebaseAuthInterop",
                "_FirebaseCoreExtension",
                "_FirebaseStorage",
                "_GTMSessionFetcher"
            ],
            path: "Sources/FirebaseStorage"
        ),
        .target(
            name: "GoogleSignInTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                .target(name: "_AppAuth", condition: .when(platforms: [.iOS])),
                "_AppCheckCore",
                .target(name: "_GoogleSignIn", condition: .when(platforms: [.iOS])),
                .target(name: "_GTMAppAuth", condition: .when(platforms: [.iOS])),
                "_GTMSessionFetcher"
            ],
            path: "Sources/GoogleSignIn"
        )
        ,
        .binaryTarget(
            name: "_absl",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_absl.xcframework.zip",
            checksum: "35ea63081d541a1b8733eb086cd5a6bdb39f298a0d083777d3b5b1e1b02fddf4"
        ),
        .binaryTarget(
            name: "_AppAuth",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_AppAuth.xcframework.zip",
            checksum: "44b91fa67d6241e4c5670219bdc32016832b078671f137fcb515dd23d76e60e5"
        ),
        .binaryTarget(
            name: "_AppCheckCore",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_AppCheckCore.xcframework.zip",
            checksum: "5c6a732849113207072e3b68df63e85537011c2e3b5e429ed9cd5576e930ccf5"
        ),
        .binaryTarget(
            name: "_FBLPromises",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FBLPromises.xcframework.zip",
            checksum: "c835949a7a00510047a8ff8a440bc8bb73cb16b6444ac5b69843d7959ce3c356"
        ),
        .binaryTarget(
            name: "_FirebaseABTesting",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseABTesting.xcframework.zip",
            checksum: "8fbda16bbd118d5ae929a10d496fe3ea5ec51b67c72d632d1abb4046dce857c0"
        ),
        .binaryTarget(
            name: "_FirebaseAILogic",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAILogic.xcframework.zip",
            checksum: "3118a81ace9018a19e8101e681866db9e5ab64e935064612eb10c9e3e33cc635"
        ),
        .binaryTarget(
            name: "_FirebaseAnalytics",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAnalytics.xcframework.zip",
            checksum: "0f0b9da1caa83690e9be0e1360e3fa43ea8224f21a3836543e0dafcffec0cc2e"
        ),
        .binaryTarget(
            name: "_FirebaseAppCheck",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAppCheck.xcframework.zip",
            checksum: "825c129b844bd28fc8673b07636d90ae616f5f0fc8200d1d47ceb132f4a6bea6"
        ),
        .binaryTarget(
            name: "_FirebaseAppCheckInterop",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAppCheckInterop.xcframework.zip",
            checksum: "63cef77ca7a8741c8f7af7909eb93cdcb0814797896538d76ec65a44623b12c6"
        ),
        .binaryTarget(
            name: "_FirebaseAppDistribution",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAppDistribution.xcframework.zip",
            checksum: "63ea3e5d475eb4285ca4a9d02fcfe21869c045b54017bd1511b9817f0c961f3a"
        ),
        .binaryTarget(
            name: "_FirebaseAuth",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAuth.xcframework.zip",
            checksum: "c1bfa3405e9f54358a4cf815c93a273251a8b5a30b6025fe872aaefa6f437af9"
        ),
        .binaryTarget(
            name: "_FirebaseAuthInterop",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAuthInterop.xcframework.zip",
            checksum: "bf1ffee05551bcd3d024ecaefa0d55ff8b8f1788596411f6cf57411a1b73470a"
        ),
        .binaryTarget(
            name: "_FirebaseCore",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseCore.xcframework.zip",
            checksum: "826e8f7b9004bea9e744d462c2e459e795c8b11f1f130c6aeb25fe8ad87832c1"
        ),
        .binaryTarget(
            name: "_FirebaseCoreExtension",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseCoreExtension.xcframework.zip",
            checksum: "2bc57c3ff91a01f0add5e1084517a291f7b335a3af076a9a281c250191d4b817"
        ),
        .binaryTarget(
            name: "_FirebaseCoreInternal",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseCoreInternal.xcframework.zip",
            checksum: "89dc78b4ccb5dc0ff8da5d02f162b87948ac0d407abffc22711d2e3497b42855"
        ),
        .binaryTarget(
            name: "_FirebaseCrashlytics",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseCrashlytics.xcframework.zip",
            checksum: "3a71e4763c300e3d84cef1e99ac9f96c3b56b484bac00c0ced36d5d0d984a3e3"
        ),
        .binaryTarget(
            name: "_FirebaseDatabase",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseDatabase.xcframework.zip",
            checksum: "36f83909c39afa9ef1e7b0651f09c0cf0fe81a5b12fef472db70e5336913ac82"
        ),
        .binaryTarget(
            name: "_FirebaseFirestore",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseFirestore.xcframework.zip",
            checksum: "0d2476c35771310e8a30ac6b90f52c6e42efe6f5a05771d502d5269a7eb8dd22"
        ),
        .binaryTarget(
            name: "_FirebaseFirestoreInternal",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseFirestoreInternal.xcframework.zip",
            checksum: "01c008f92748ef8a81e39b5ca51b2e9138ec58d9a7fcdce814b461d9dccfb5b8"
        ),
        .binaryTarget(
            name: "_FirebaseFunctions",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseFunctions.xcframework.zip",
            checksum: "6dbed569875d1baf5ca359b0c5e3f8ce5de26fefe8af017764656e47858b417e"
        ),
        .binaryTarget(
            name: "_FirebaseInAppMessaging",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseInAppMessaging.xcframework.zip",
            checksum: "11d598d7ca202b8c6fd66cc7a52aef6f40e7ca35136764d95d422a43ef71171e"
        ),
        .binaryTarget(
            name: "_FirebaseInstallations",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseInstallations.xcframework.zip",
            checksum: "6ad503757de700e7f505cf8d121f6c9fec47c713a4f8b6f0ccb9158bc2b83a2d"
        ),
        .binaryTarget(
            name: "_FirebaseMessaging",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseMessaging.xcframework.zip",
            checksum: "092a2a304999fd9a617353ac9e1fceba975fe76da4fb70e62c85d33ff00d34a3"
        ),
        .binaryTarget(
            name: "_FirebaseMessagingInterop",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseMessagingInterop.xcframework.zip",
            checksum: "ddb86dadd1f0505a73e453ba572781785f1cba158a34ba1ada1c460684f738db"
        ),
        .binaryTarget(
            name: "_FirebaseMLModelDownloader",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseMLModelDownloader.xcframework.zip",
            checksum: "0a5440f9fd018e68122ed2f8caa3e8f09054d346db8379b07e270a3369ed0821"
        ),
        .binaryTarget(
            name: "_FirebasePerformance",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebasePerformance.xcframework.zip",
            checksum: "c903c018e1fc31507709862ce9bb502e338606e9e244b25255d86c6ca9697202"
        ),
        .binaryTarget(
            name: "_FirebaseRemoteConfig",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseRemoteConfig.xcframework.zip",
            checksum: "ef9ade422744ca8db9686f58d45950e2171b6f85913729393008982aa865ab01"
        ),
        .binaryTarget(
            name: "_FirebaseRemoteConfigInterop",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseRemoteConfigInterop.xcframework.zip",
            checksum: "65552fe8eccfddaab6a99f4a73f3addb850aa2a455cde3dfc9e563ab108ec794"
        ),
        .binaryTarget(
            name: "_FirebaseSessions",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseSessions.xcframework.zip",
            checksum: "2b46b96a359ed13a3876fb71eaee244f2fa35754b2fe969224f78763aa8372f3"
        ),
        .binaryTarget(
            name: "_FirebaseSharedSwift",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseSharedSwift.xcframework.zip",
            checksum: "23959db59c28b9551b8fee1d0e441d60bb2011aa18f8c5b43d362304da279c76"
        ),
        .binaryTarget(
            name: "_FirebaseStorage",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseStorage.xcframework.zip",
            checksum: "feef75c9baeea576f9737f780042e463e8e282210d8307367decc19c3549e4fe"
        ),
        .binaryTarget(
            name: "_GoogleAdsOnDeviceConversion",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GoogleAdsOnDeviceConversion.xcframework.zip",
            checksum: "2c85b78bd7b63fb467a40fdd68dedbb1f879daae263be9a98a1ea2ca19fa7bd7"
        ),
        .binaryTarget(
            name: "_GoogleAppMeasurement",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GoogleAppMeasurement.xcframework.zip",
            checksum: "42c031f2d247b22aa8e4469f655d213ea1f7ebe170104b6382d50e88a4b6e558"
        ),
        .binaryTarget(
            name: "_GoogleAppMeasurementIdentitySupport",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GoogleAppMeasurementIdentitySupport.xcframework.zip",
            checksum: "052a71d763f5e25ca135d92b34c305630c08ac2e998fa1ce14fa261d591ed07b"
        ),
        .binaryTarget(
            name: "_GoogleDataTransport",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GoogleDataTransport.xcframework.zip",
            checksum: "d482841ce611ba197e069081c534ebe5b61f5c5744cd1c85cc36cfc5c2195360"
        ),
        .binaryTarget(
            name: "_GoogleSignIn",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GoogleSignIn.xcframework.zip",
            checksum: "8124ef090617d81e9cfc2679d13053d7e3de5e607bc3eb94719a5a74f07616cd"
        ),
        .binaryTarget(
            name: "_GoogleUtilities",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GoogleUtilities.xcframework.zip",
            checksum: "9849a78413f5da5de687d61cd9e4efdd7de25f69be7bfcb8ebe2ab854b3fd66d"
        ),
        .binaryTarget(
            name: "_grpc",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_grpc.xcframework.zip",
            checksum: "3d4527befade28d40f9101c7a2dbd6cdf9fae6259c3ca92c2ad9b409b7c9508c"
        ),
        .binaryTarget(
            name: "_grpcpp",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_grpcpp.xcframework.zip",
            checksum: "c2e267b19a9a63a2791017dffb85885fded161ae856b4670dc12e78fd0d8df1e"
        ),
        .binaryTarget(
            name: "_GTMAppAuth",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GTMAppAuth.xcframework.zip",
            checksum: "134bb4ac78b72398d8137bb66c92d86ba166b3d47d18e703d7b56ff7746d96a7"
        ),
        .binaryTarget(
            name: "_GTMSessionFetcher",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GTMSessionFetcher.xcframework.zip",
            checksum: "7aaff9eceaf2591cc79093bc10dc5facc05c7e2a1fdd2a1afb6c22ae0f7fd7f2"
        ),
        .binaryTarget(
            name: "_leveldb",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_leveldb.xcframework.zip",
            checksum: "17a38575adff5a2d8d2b56191798219d119250fe1b60bf0b13e4d876f21ac08c"
        ),
        .binaryTarget(
            name: "_nanopb",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_nanopb.xcframework.zip",
            checksum: "cc2796d4a8c7aa624fed8b9270eee76a91c94c7702148f8dedf324b3fc9360cb"
        ),
        .binaryTarget(
            name: "_openssl_grpc",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_openssl_grpc.xcframework.zip",
            checksum: "6cc03412208dfbc6e62e1471cef1613b08d76739ab9abb1a6b39063183ed864c"
        ),
        .binaryTarget(
            name: "_Promises",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_Promises.xcframework.zip",
            checksum: "45de9cf34a0421a164f7bcc355b1daf11003558dee6e784d4464bc1953004fe2"
        ),
        .binaryTarget(
            name: "_RecaptchaInterop",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_RecaptchaInterop.xcframework.zip",
            checksum: "ad7d5de92c3edd5c6f2af1c74e260599b7298b797920ffe1dbcc9aac7e371f3d"
        )
    ]
)