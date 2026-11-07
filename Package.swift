// swift-tools-version: 5.9
import PackageDescription
let package = Package(
    name: "fontctl",
    platforms: [.macOS(.v13)],
    products: [.executable(name: "fontctl", targets: ["fontctl"])],
    targets: [
        .target(name: "FontControl", linkerSettings: [.linkedFramework("CoreText")]),
        .executableTarget(name: "fontctl", dependencies: ["FontControl"]),
        .executableTarget(name: "fontctl-checks", dependencies: ["FontControl"], path: "Tests/FontControlTests")
    ]
)
