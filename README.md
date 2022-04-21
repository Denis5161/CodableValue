# CodableValue

Decode UIColor and UIImage by utilizing Swift's Property Wrappers included in Swift 5.1

## How to install
Only Swift Package Manager is supported as of this release. I have no plans to support other package managers, like CocoaPods or Carthage.

Add these lines to an existing `Packages.swift` file:
```swift
    .package(url: "https://github.com/JohnSundell/Files",
```
Or use Xcode to add a package. See [Swift Package Documentation.](https://github.com/apple/swift-package-manager/tree/master/Documentation) for more info.

## How to use
The type must implement its own `swift Encodable` function.

Declare a property wrapper on a type that you wish to use.
For example:
```swift
    @CodableValue var image: UIImage?
    @CodableValue var color: UIColor
```

When initializing the value, for example in an init method:
```swift
    init(image: UIImage?, color: UIColor) {
        self.image = CodableValue(wrappedValue: image, type: .image, isOptional: true)
        self.color = CodableValue(wrappedValue: color, type: .color, isOptional: false)
    }
```

## Good to Know
`CodableValue` conforms to `Equatable`, if the wrapped value also conforms to it.

I have included a default extension on UIColor and UIImage for `Encodable`. Feel free to change the implementation.

##Purpose of this Package
The purpose of this package was for me to learn about Property Wrappers. Some types don't conform to Codable and can't synthesize the needed methods automatically. When a data model only has a few of these properties - while the rest support Codable - then it's better to have the compiler synthesize Codable conformance automatically instead of writing a lot of boilerplate code for properties that already support it. 
Adding Encodable conformance to a UIKit type works easily inside of an extension on that type. But Decodable conformance does not work, because it is a required initializer and I'm guessing the implementation details of UIKit classes stop one from creating the `init(from decoder: Decoder)` method inside an extension.
I have spent a considerable amount of time fiddling with this, and this solution seems the most stable and easiest to understand from an API perspective.
