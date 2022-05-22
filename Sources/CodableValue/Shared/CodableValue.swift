//
//  CodableValue.swift
//
//
//  Created by Denis Goldberg on 20.04.22.
//
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
///A property wrapper that adds Codable conformance to a generic type `T`, when the type cannot directly conform to Codable.
///
///The Type `T` implements the `Encodable` protocol and is restricted to be one of the `SupportedCodableTypes` inside the property wrapper.
///
///- Note: If appending a property observer to your wrapped property, then make sure to apply any changes to the **$\<Your Value\>** property! Otherwise code will crash with bad access.
@propertyWrapper
public struct CodableValue<T: CodableValueSupported>: Codable {
    
    ///CodableValue encodes its wrapped value as the specified image type.
    ///- Note: Only for Images.
    var imageEncodingFileType  = ImageEncodingFileTypes.jpeg
    
    #if canImport(UIKit)
    ///The JPEG compression quality to use, if the wrapped value should be encoded as jpeg data.
    ///- Note: Only for UIImages.
    var imageEncodingCompression = 0.3
    #endif
    
    public var wrappedValue: T
    
    public var projectedValue: T { get { wrappedValue } set { wrappedValue = newValue } }
    
    ///Initializes `CodableValue`.
    ///
    ///- Parameter wrappedValue: The value of the wrapped property.
    public init(wrappedValue: T) { self.wrappedValue = wrappedValue }
    
    public init(from decoder: Decoder) throws {
        switch T.type {
        case .color:
            #if canImport(UIKit)
            wrappedValue = try Self.decode(UIColor.self, from: decoder, with: [UIColor.ColorRGBA : CGFloat]?.self, initializer: UIColor.init(from:))
            #elseif canImport(AppKit)
            wrappedValue = try Self.decode(NSColor.self, from: decoder, with: [NSColor.ColorRGBA : CGFloat]?.self, initializer: NSColor.init(from:))
            #endif
        case .image:
            #if canImport(UIKit)
            wrappedValue = try Self.decode(UIImage.self, from: decoder, with: Data?.self, initializer: UIImage.init(data:))
            #elseif canImport(AppKit)
            wrappedValue = try Self.decode(NSImage.self, from: decoder, with: Data?.self, initializer: NSImage.init(data:))
            #endif
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch T.type {
        case .color:
            try container.encode(wrappedValue)
        case .image:
            #if canImport(UIKit)
            let data = UIImage.data(from: wrappedValue as? UIImage, for: imageEncodingFileType, with: imageEncodingCompression)
            #elseif canImport(Appkit)
            let data = NSImage.data(from: wrappedValue as? NSImage, for: imageEncodingFileType)
            #endif
            
            try container.encode(data)
        }
    }
    
    ///Modular function to simplify the code base.
    /// - Parameters:
    ///     - base: Relevant for the `initializer` parameter. What the initalizer method returns.
    ///     - decoder: The decoder that holds the requested data for the wrapped value.
    ///     - dataDecoding: Must be Decodable. The swift representation of what is actually saved inside the container.
    ///     - initializer: A function that initializes an object by passing in the decoded data and returns the object as an optional `Base` type.
    /// - Returns:
    ///     The decoded object as type `T`.
    /// - Throws: DecodingValueError when decoding fails.
    private static func decode<Base, DataDecoding: Decodable>(_ base: Base.Type, from decoder: Decoder, with dataDecoding: DataDecoding?.Type, initializer: (DataDecoding)->Base?) throws -> T {
        let container = try decoder.singleValueContainer()
        if let data = try? container.decode(dataDecoding) {
            guard let initialized = initializer(data) as? T else { throw DecodingValueError<Base, T>.decodingTypeMismatch }
            return initialized
        } else {
            guard T.self is ExpressibleByNilLiteral.Type else { throw DecodingValueError<Base, T>.nonOptionalDecodingError }
            guard let noValue = Base?.none as? T else { throw DecodingValueError<Base, T>.decodingTypeMismatch }
            return noValue
        }
        
    }
}
//MARK: - Protocol Conformances
//Putting these extensions here, instead of in a separate file, so that the compiler can automatically generate the conformances for CodableValue.

extension CodableValue: Equatable where T: Equatable { }

extension CodableValue: Hashable where T: Hashable { }
