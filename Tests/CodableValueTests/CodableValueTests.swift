//
//  CodableValueTests.swift
//  
//
//  Created by Denis Goldberg on 20.04.22.
//

import XCTest
@testable import CodableValue

final class CodableValueTests: XCTestCase {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func testCodableOptionalImage() {
        let optionalImage = CodableValue(wrappedValue: TestImage.image, type: .image)
    
        XCTAssertNoThrow(try encoder.encode(optionalImage))
        
        let encoded = try! encoder.encode(optionalImage)
        
        let decoder = JSONDecoder()
        
        XCTAssertThrowsError(try decoder.decode(CodableValue<UIImage>.self, from: encoded))
        XCTAssertNoThrow(try decoder.decode(CodableValue<UIImage?>.self, from: encoded))
        let decodedOptionalImage = try! decoder.decode(CodableValue<UIImage?>.self, from: encoded)
        
        XCTAssertEqual(optionalImage, decodedOptionalImage)
        
    }
    
    func testCodableOptionalNilImage() {
        let optionalImage = CodableValue(wrappedValue: nil as UIImage?, type: .image)
        
        XCTAssertNoThrow(try encoder.encode(optionalImage))
        
        let encoded = try! encoder.encode(optionalImage)
        
        let decoder = JSONDecoder()
        
        XCTAssertThrowsError(try decoder.decode(CodableValue<UIImage>.self, from: encoded))
        XCTAssertNoThrow(try decoder.decode(CodableValue<UIImage?>.self, from: encoded))
        
        let decodedOptionalImage = try! decoder.decode(CodableValue<UIImage?>.self, from: encoded)
        
        XCTAssertEqual(optionalImage, decodedOptionalImage)
        
    }
    
    func testCodableNonOptionalImage() {
        let image = CodableValue(wrappedValue: TestImage.image ?? UIImage(), type: .image)

        XCTAssertNoThrow(try encoder.encode(image))

        let encoded = try! encoder.encode(image)

        let decoder = JSONDecoder()

        XCTAssertNoThrow(try decoder.decode(CodableValue<UIImage>.self, from: encoded))
        let decodedImage = try! decoder.decode(CodableValue<UIImage>.self, from: encoded)

        XCTAssertEqual(image, decodedImage)
    }
    
    func testCodableOptionalColor() {
        let optionalColor = CodableValue(wrappedValue: UIColor.init(red: 1, green: 1, blue: 1, alpha: 1) as UIColor?, type: .color)
        
        XCTAssertNoThrow(try encoder.encode(optionalColor))
        
        let encoded = try! encoder.encode(optionalColor)
        
        XCTAssertNoThrow(try decoder.decode(CodableValue<UIColor?>.self, from: encoded))
        let decodedOptionalColor = try! decoder.decode(CodableValue<UIColor?>.self, from: encoded)
        
        XCTAssertEqual(optionalColor, decodedOptionalColor)
    }
    
    func testCodableOptionalNilColor() {
        let optionalColor = CodableValue(wrappedValue: nil as UIColor?, type: .color)
        
        XCTAssertNoThrow(try encoder.encode(optionalColor))
        let encoded = try! encoder.encode(optionalColor)
        
        XCTAssertThrowsError(try decoder.decode(CodableValue<UIColor>.self, from: encoded))
        XCTAssertNoThrow(try decoder.decode(CodableValue<UIColor?>.self, from: encoded))
        let decodedOptionalColor = try! decoder.decode(CodableValue<UIColor?>.self, from: encoded)
        
        XCTAssertEqual(optionalColor, decodedOptionalColor)
    }
    
    func testCodableNonOptionalColor() {
        let color = CodableValue(wrappedValue: UIColor.init(red: 1, green: 1, blue: 1, alpha: 1), type: .color)
        
        XCTAssertNoThrow(try encoder.encode(color))
        
        let encoded = try! encoder.encode(color)

        XCTAssertNoThrow(try decoder.decode(CodableValue<UIColor>.self, from: encoded))
        let decodedColor = try! decoder.decode(CodableValue<UIColor>.self, from: encoded)
        
        XCTAssertEqual(color, decodedColor)
    }
}

extension CodableValueTests {
    enum TestImage {
        static let image = UIImage(data: Self.data)
        static let data = "Hello".data(using: .utf8)!
    }
}
