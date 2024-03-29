# CodableValue

**Decode UIColor and UIImage (UIKit), and NSColor and NSImage (AppKit) by utilizing Swift's Property Wrappers included in Swift 5.1**

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FDenis5161%2FCodableValue%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Denis5161/CodableValue)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FDenis5161%2FCodableValue%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Denis5161/CodableValue)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-orange)](https://www.swift.org/package-manager/)

[![GitHub last commit](https://img.shields.io/github/last-commit/Denis5161/CodableValue)](https://github.com/Denis5161/CodableValue/commits/main) 
[![GitHub license](https://img.shields.io/github/license/Denis5161/CodableValue)](https://github.com/Denis5161/CodableValue/blob/main/LICENSE)

## Installation
Only Swift Package Manager is supported as of this release. I have no plans to support other package managers, like CocoaPods or Carthage.

Add these lines inside an existing `Packages.swift` file:
```swift
dependencies: [
    .package(url: "https://github.com/Denis5161/CodableValue.git", from: "6.0.1")
]
```
Or use Xcode to add a package. See [Swift Package Documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation) for more info.

## Requirements
- Swift 5.3+
- iOS 13.0+ || macOS 11+ || watchOS 6.3+

## How to Use
`@CodableValue` can encode/ decode the following types:
- images (UIImage/NSImage)
- colors (UIColor/NSColor)

The property wrapper is designed to be very transparent to the API user. Optionals work with the same property wrapper.

Declare a property wrapper on a property that you wish to use. For example:
```swift
@CodableValue var image: UIImage?
@CodableValue var swiftImage = UIImage(systemName: "swift")!


@CodableValue var color: UIColor = .systemBlue
```

When initializing the values, for example in an init method of a custom type:
```swift
init(image: UIImage?, color: UIColor) {
    self.image = image
    self.color = color
}
```

### Or in AppKit. For example:
```swift
@CodableValue var image: NSImage?
@CodableValue var color: NSColor
```

## Good to Know
`CodableValue` conforms to `Equatable`, if the wrapped value also conforms to it.

`CodableValue` conforms to `Hashable`, if the wrapped value also conforms to it.

## Purpose of this Package
The purpose of this package was for me to learn about Property Wrappers. Some types don't conform to Codable and can't synthesize the needed methods automatically. When a data model only has a few of these properties - while the rest support Codable - then it's better to have the compiler synthesize Codable conformance automatically instead of writing a lot of boilerplate code for properties that already support it. 
Adding Encodable conformance to a UIKit type works easily inside of an extension on that type. But Decodable conformance does not work, because it is a required initializer and I'm guessing the implementation details of UIKit classes stop one from creating the `init(from decoder: Decoder)` method inside an extension.
I have spent a considerable amount of time fiddling with this, and this solution seems to be the most stable and easiest to understand from an API perspective.

## License
Provided under the MIT License. See [LICENSE](https://github.com/Denis5161/CodableValue/blob/main/LICENSE) for more info.
