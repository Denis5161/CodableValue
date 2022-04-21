import UIKit

///A property wrapper that adds Codable conformance to a generic type `T`, when the type cannot directly conform to Codable.
///
///The Type `T` implements the `Encodable` protocol and is restricted to be one of the `SupportedCodableTypes` inside the property wrapper.
///The implementation details of decoding a value from the decoder necessitate an extra `type` value, because I have no way of knowing what type is inside the wrappedValue due to its generic nature. Also setting property `isOptional` to tell if the property can have no value.
///
@propertyWrapper
public struct CodableValue<T: Encodable>: Codable {
    ///`CodableValue` supports the Encoding and Decoding of these UIKit types.
    public enum SupportedCodableTypes: String, Codable {
        case image, color
    }
    
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
            if let colorRGBA = try container.decode([UIKit.UIColor.ColorRGBA : CoreGraphics.CGFloat]?.self, forKey: .wrappedValue) {
                guard let color = UIColor(from: colorRGBA) as? T else { throw DecodingValueError<T>.decodingTypeMismatch }
                wrappedValue = color
            } else {
                guard T.self == UIColor?.self else { throw DecodingValueError<T>.nonOptionalDecodingError }
                guard let none = Optional<UIColor>.none as? T else { throw DecodingValueError<T>.decodingTypeMismatch }
                
                wrappedValue = none
            }
        case .image:
            if let imageData = try container.decode(Data?.self, forKey: .wrappedValue) {
                guard let image = UIImage(data: imageData) as? T else { throw DecodingValueError<T>.decodingTypeMismatch }
                wrappedValue = image
            } else {
                guard T.self == UIImage?.self else { throw DecodingValueError<T>.nonOptionalDecodingError }
                guard let none = Optional<UIImage>.none as? T else { throw DecodingValueError<T>.decodingTypeMismatch }
                wrappedValue = none
            }
            
        }
    }
}

extension CodableValue: Equatable where T: Equatable { }
