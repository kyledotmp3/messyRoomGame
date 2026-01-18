// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MessyRoomGame",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "MessyRoomGameLib",
            targets: ["MessyRoomGameLib"]),
    ],
    targets: [
        .target(
            name: "MessyRoomGameLib",
            dependencies: [],
            path: "MessyRoomGame",
            exclude: [
                "Info.plist",
                "AppDelegate.swift",
                "SceneDelegate.swift",
                "GameViewController.swift",
                "Assets.xcassets",
                "Resources/Sounds"
            ],
            sources: [
                "Models",
                "Managers",
                "Scenes"
            ],
            resources: [
                .copy("Resources/Data/Men.plist"),
                .copy("Resources/Data/Room_gamer_gary.plist")
            ]
        )
    ]
)
