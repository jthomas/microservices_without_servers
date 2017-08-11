// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "WeatherBot",
    dependencies: [
      .Package(url: "https://github.com/IBM-Swift/Kitura-net.git", "1.7.10"),
      .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", "15.0.1"),
    ]
)
