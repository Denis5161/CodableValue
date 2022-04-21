import UIKit

///A property wrapper that adds Codable conformance to a generic type `T`, when the type cannot directly conform to Codable.
///
///The Type `T` implements the `Encodable` protocol and is restricted to be one of the `SupportedCodableTypes` inside the property wrapper.
///The implementation details of decoding a value from the decoder necessitate an extra `type` value, because I have no way of knowing what type is inside the wrappedValue due to its generic nature. Also setting property `isOptional` to tell if the property can have no value.
///
@propertyWrapper
public struct CodableValue<T: Encodable>: Codable {
    ///`CodableValue` supports the Encoding and Decoding of these UIKit types.
    ///
    /// Use any of the supplied cases to provide `CodableValue` with the correct wrappedValue type.
    /// 
    /// - Important: Using mismatching types will throw a `DecodingValueError` when `CodableValue` is initialized from a Decoder.
    public enum SupportedCodableTypes: String, Codable { case image, color }
    
    private enum CodingKeys: CodingKey { case type, wrappedValue }
    
    ///The type of the value.
    private let type: SupportedCodableTypes
    
    public var wrappedValue: T
    
    ///Initializes `CodableValue`.
    ///
    ///- Parameters:
    ///     - wrappedValue: The value of the wrapped property.
    ///     - type: The type of the value, which must be one of the supported types.
    public init(wrappedValue: T, type: SupportedCodableTypes) {
        self.wrappedValue = wrappedValue
        self.type = type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(SupportedCodableTypes.self, forKey: .type)
    
        switch type {
        case .color:
            wrappedValue = try Self.decode(UIColor.self, from: container, with: [UIKit.UIColor.ColorRGBA : CoreGraphics.CGFloat]?.self, initializer: UIColor.init(from:))
        case .image:
            wrappedValue = try Self.decode(UIImage.self, from: container, with: Data?.self, initializer: UIImage.init(data:))
        }
    }
    
    ///Modular function to simplify the code base.
    /// - Parameters:
    ///     - base: Relevant for the `initializer` parameter. What the initalizer method returns.
    ///     - container: The container that holds the requested data for the wrapped value.
    ///     - dataDecoding: Must be Decodable. The swift representation of what is actually saved inside the container.
    ///     - initializer: A function that initializes an object by passing in the decoded data and returns the object as an optional `Base` type.
    /// - Returns:
    ///     The decoded object as type `T`.
    /// - Throws: DecodingValueError when decoding fails.
    private static func decode<Base, DataDecoding: Decodable>(_ base: Base.Type, from container: KeyedDecodingContainer<CodingKeys>, with dataDecoding: DataDecoding?.Type, initializer: (DataDecoding)->Base?) throws -> T {
        if let data = try container.decode(dataDecoding, forKey: .wrappedValue) {
            guard let initialized = initializer(data) as? T else { throw DecodingValueError<T>.decodingTypeMismatch }
            return initialized
        } else {
            guard T.self is ExpressibleByNilLiteral.Type else { throw DecodingValueError<T>.nonOptionalDecodingError }
            guard let noValue = Base?.none as? T else { throw DecodingValueError<T>.decodingTypeMismatch }
            return noValue
        }
        
    }
}

extension CodableValue: Equatable where T: Equatable { }
