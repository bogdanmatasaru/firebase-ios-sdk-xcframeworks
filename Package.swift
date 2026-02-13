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
            checksum: "546b58be238b12a175bfea69202932da1af53f2d958c213f4bc4d73b4215160c"
        ),
        .binaryTarget(
            name: "_AppAuth",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_AppAuth.xcframework.zip",
            checksum: "f15173dfa0ae0794b5e23f7f1c6df32307018c79e89a2dfb1b94f7e67964a4e0"
        ),
        .binaryTarget(
            name: "_AppCheckCore",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_AppCheckCore.xcframework.zip",
            checksum: "1d9630813c0c8409b68c578d7c7b8f325c214c027693b0e5a445c7bcc84aec9a"
        ),
        .binaryTarget(
            name: "_FBLPromises",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FBLPromises.xcframework.zip",
            checksum: "1de365be01dc6c2da026405d3f1a52a2b863b73edba554cf5e57789a6097a887"
        ),
        .binaryTarget(
            name: "_FirebaseABTesting",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseABTesting.xcframework.zip",
            checksum: "5b98233e67d33433969f8b88f55c7a1381f65890666ae36d113d4931a7740ed6"
        ),
        .binaryTarget(
            name: "_FirebaseAILogic",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAILogic.xcframework.zip",
            checksum: "44f887fa7d4f4fd0e004c7638a8b7576209983cbf499658f65a0677d7f3e1147"
        ),
        .binaryTarget(
            name: "_FirebaseAnalytics",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAnalytics.xcframework.zip",
            checksum: "4f4a5bd96609eea130ed4e80f3376f121e76ade0c881895764513717c2c6f85b"
        ),
        .binaryTarget(
            name: "_FirebaseAppCheck",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAppCheck.xcframework.zip",
            checksum: "62f3be2ab9481a3ec8b721252ab87447d35dc811fc18dcc6c22944329855d813"
        ),
        .binaryTarget(
            name: "_FirebaseAppCheckInterop",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAppCheckInterop.xcframework.zip",
            checksum: "1f1df576a4c0a07cbb3cae535e0e4570c91213845733d6f5f8b126f6ead87f14"
        ),
        .binaryTarget(
            name: "_FirebaseAppDistribution",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAppDistribution.xcframework.zip",
            checksum: "e59337d9ab79b2b09ee2d56842c0288bf605fab34b8bb6fbbe5636e82c2dafe4"
        ),
        .binaryTarget(
            name: "_FirebaseAuth",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAuth.xcframework.zip",
            checksum: "9bea8946a94c4bc4162529c3fa170335030a708dcedbf8a59bd2ac7be9452af0"
        ),
        .binaryTarget(
            name: "_FirebaseAuthInterop",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseAuthInterop.xcframework.zip",
            checksum: "f398b9717f687818784ff2c66810f199f5f5f7690fe27329f1b9ff0aa0b6a0ad"
        ),
        .binaryTarget(
            name: "_FirebaseCore",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseCore.xcframework.zip",
            checksum: "b718db0b95aae5e01c413690156843dc54554664ebc7ebeb04f34fed2be7de1d"
        ),
        .binaryTarget(
            name: "_FirebaseCoreExtension",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseCoreExtension.xcframework.zip",
            checksum: "8cc3a45d55437ae2fef6357b7e2ecb657f5cb77dcd62ec3a5b8a0d5f614074b0"
        ),
        .binaryTarget(
            name: "_FirebaseCoreInternal",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseCoreInternal.xcframework.zip",
            checksum: "301b82e0e4447bbe20d26f38dd488cfc91d41c983c9a4b43ca6042d2cf831b2b"
        ),
        .binaryTarget(
            name: "_FirebaseCrashlytics",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseCrashlytics.xcframework.zip",
            checksum: "b7ea3e52b3fe36ffda0ef1ce24e6b0e3182f6d6c2d2e2b4c0b8a4a20694ecafc"
        ),
        .binaryTarget(
            name: "_FirebaseDatabase",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseDatabase.xcframework.zip",
            checksum: "a3d49894c1a90c911d99368bae02ac3bb27bbb6c0b7c5acef047ebb3d440a338"
        ),
        .binaryTarget(
            name: "_FirebaseFirestore",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseFirestore.xcframework.zip",
            checksum: "5d9469c577b3e928ae352f601469bb626edb62907e1187ca24dfd2850524e0cb"
        ),
        .binaryTarget(
            name: "_FirebaseFirestoreInternal",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseFirestoreInternal.xcframework.zip",
            checksum: "fee82a85a1525a016034f683b7c67068c32041be4e369439f6b2da6886da5089"
        ),
        .binaryTarget(
            name: "_FirebaseFunctions",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseFunctions.xcframework.zip",
            checksum: "691c444cd1e811615e89c99e902eff184448040cb8a4d22d7f5ff1e65f43e447"
        ),
        .binaryTarget(
            name: "_FirebaseInAppMessaging",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseInAppMessaging.xcframework.zip",
            checksum: "8374b1d8e02118e7674b87f22cbbeae0876e44d44d49ede68407dc772dda23fc"
        ),
        .binaryTarget(
            name: "_FirebaseInstallations",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseInstallations.xcframework.zip",
            checksum: "0ea96c43bb724896e20c3eaad6a8b00e3146c3a3a9e0bd0b2ea528f211464b9a"
        ),
        .binaryTarget(
            name: "_FirebaseMessaging",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseMessaging.xcframework.zip",
            checksum: "f6c4bd0a06cd98769ca46a29e0e1719b4d9e0855996cbfe1bd7c94e1e5ec0754"
        ),
        .binaryTarget(
            name: "_FirebaseMessagingInterop",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseMessagingInterop.xcframework.zip",
            checksum: "26eed4b0f8ca123c28b11e323af1c88e0ef6d3c276d437685c1b5b6784ac8af7"
        ),
        .binaryTarget(
            name: "_FirebaseMLModelDownloader",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseMLModelDownloader.xcframework.zip",
            checksum: "84198957bf9da169f0a63d41d93e42dce095d286409bf247ed91fdd383ae84a2"
        ),
        .binaryTarget(
            name: "_FirebasePerformance",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebasePerformance.xcframework.zip",
            checksum: "31e2d088d00d3e23a04123cfe5b604b8dee687284d46eaaa2f1799599e283b03"
        ),
        .binaryTarget(
            name: "_FirebaseRemoteConfig",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseRemoteConfig.xcframework.zip",
            checksum: "220fc5880118df1a4abb34bfd193e255d1c7dbf1d93f0434547762e2adefd340"
        ),
        .binaryTarget(
            name: "_FirebaseRemoteConfigInterop",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseRemoteConfigInterop.xcframework.zip",
            checksum: "7e35715b95833c42df8674789a365d100c16abef63d64fff30bfcf96aaacf664"
        ),
        .binaryTarget(
            name: "_FirebaseSessions",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseSessions.xcframework.zip",
            checksum: "f6bb307af56bceea436c718aa268d68105ba968cf0fd04eec31409a62881187d"
        ),
        .binaryTarget(
            name: "_FirebaseSharedSwift",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseSharedSwift.xcframework.zip",
            checksum: "e81602478fbe4c950eb7bd6148ab95232a8fe3f340ac3cbfe7738854547d2fe7"
        ),
        .binaryTarget(
            name: "_FirebaseStorage",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_FirebaseStorage.xcframework.zip",
            checksum: "c39db05e04ccb13463400503a8c654a6f1320cd40b5cb10437ea57eb733a30d9"
        ),
        .binaryTarget(
            name: "_GoogleAdsOnDeviceConversion",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GoogleAdsOnDeviceConversion.xcframework.zip",
            checksum: "2c85b78bd7b63fb467a40fdd68dedbb1f879daae263be9a98a1ea2ca19fa7bd7"
        ),
        .binaryTarget(
            name: "_GoogleAppMeasurement",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GoogleAppMeasurement.xcframework.zip",
            checksum: "49053f4a84ffcad2db8fb1c16c68ab0635406e08f7803609a3e3f9ef70be3127"
        ),
        .binaryTarget(
            name: "_GoogleAppMeasurementIdentitySupport",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GoogleAppMeasurementIdentitySupport.xcframework.zip",
            checksum: "7b3f0aad3eee8f2b5e64ae22addffe9de6d670d08fb4957857bc3bda19e3ca93"
        ),
        .binaryTarget(
            name: "_GoogleDataTransport",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GoogleDataTransport.xcframework.zip",
            checksum: "a61df1ec6c1cc035fb0864ba96007636863497e9675f7ba13adb1bc58b4eeda1"
        ),
        .binaryTarget(
            name: "_GoogleSignIn",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GoogleSignIn.xcframework.zip",
            checksum: "89cc281ee242896af8a70c0adb97550880df689b4147bea49bdeadcf4b1caecb"
        ),
        .binaryTarget(
            name: "_GoogleUtilities",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GoogleUtilities.xcframework.zip",
            checksum: "11f5f359f12a6df89d1880512e6e7d585dcde50c036bc0ab4f6fe8691997e71f"
        ),
        .binaryTarget(
            name: "_grpc",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_grpc.xcframework.zip",
            checksum: "a86d8a1a7649544a1149dd561b7de0a2381c5a57c195624e5daac448bb4b3ac6"
        ),
        .binaryTarget(
            name: "_grpcpp",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_grpcpp.xcframework.zip",
            checksum: "c598704bf7e13e76dbfc7d8dc46fadbf8d260dfcd0b3e5e17da3b090896926bb"
        ),
        .binaryTarget(
            name: "_GTMAppAuth",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GTMAppAuth.xcframework.zip",
            checksum: "523e3d48f7c25af20e2ebe80eaf31c948794146674e14de29e1d2f678e119314"
        ),
        .binaryTarget(
            name: "_GTMSessionFetcher",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_GTMSessionFetcher.xcframework.zip",
            checksum: "9f2ad8d029e48acb73d8cedba8044fe017ae90d0dbec24a22c954927b723c0b9"
        ),
        .binaryTarget(
            name: "_leveldb",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_leveldb.xcframework.zip",
            checksum: "78cc1c051a0dc19e93d6523ad3443a59dfc88ef39d0d8e2d1c16e9299fe6b9bf"
        ),
        .binaryTarget(
            name: "_nanopb",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_nanopb.xcframework.zip",
            checksum: "8826b6b0df3a55909d90b7c69e9eaf358942f0aa229226361d9e0dc7bbb355e5"
        ),
        .binaryTarget(
            name: "_openssl_grpc",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_openssl_grpc.xcframework.zip",
            checksum: "12ba6f26f45be4d58c5bfd03dfb915b72a33292821f2f0e6d9f34b5603cd378b"
        ),
        .binaryTarget(
            name: "_Promises",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_Promises.xcframework.zip",
            checksum: "afa338aa3e022fa09e9bb597cc83e7476411e887239466ef61c2dce75785779d"
        ),
        .binaryTarget(
            name: "_RecaptchaInterop",
            url: "https://github.com/bogdanmatasaru/firebase-ios-sdk-xcframeworks/releases/download/12.9.0/_RecaptchaInterop.xcframework.zip",
            checksum: "bfab72ea215e7816da2e6fd300fa92ea7912fb09d494a0ab2f03ca8da832a0fd"
        )
    ]
)