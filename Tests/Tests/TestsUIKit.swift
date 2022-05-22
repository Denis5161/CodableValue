//
//  TestsUIKit.swift
//  
//
//  Created by Denis Goldberg on 20.04.22.
//

#if canImport(UIKit)

import XCTest
@testable import CodableValue

final class CodableValueTests: XCTestCase {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func testCodableOptionalImage() {
        let optionalImage = CodableValue(wrappedValue: TestImage.image)
    
        XCTAssertNoThrow(try encoder.encode(optionalImage))
        
        let encoded = try! encoder.encode(optionalImage)
        
        XCTAssertNoThrow(try decoder.decode(CodableValue<UIImage?>.self, from: encoded))
        let decodedOptionalImage = try! decoder.decode(CodableValue<UIImage?>.self, from: encoded)
        
        XCTAssertEqual(UIImage.data(from: TestImage.compressedImage), UIImage.data(from: decodedOptionalImage.wrappedValue))
        
    }
    
    func testCodableOptionalNilImage() {
        let optionalImage = CodableValue(wrappedValue: nil as UIImage?)
        
        XCTAssertNoThrow(try encoder.encode(optionalImage))
        
        let encoded = try! encoder.encode(optionalImage)
        
        XCTAssertThrowsError(try decoder.decode(CodableValue<UIImage>.self, from: encoded))
        XCTAssertNoThrow(try decoder.decode(CodableValue<UIImage?>.self, from: encoded))
        
    }
    
    func testCodableNonOptionalImage() {
        let image = CodableValue(wrappedValue: TestImage.image!)

        XCTAssertNoThrow(try encoder.encode(image))

        let encoded = try! encoder.encode(image)

        XCTAssertNoThrow(try decoder.decode(CodableValue<UIImage>.self, from: encoded))
        let decodedImage = try! decoder.decode(CodableValue<UIImage>.self, from: encoded)

        XCTAssertEqual(UIImage.data(from: TestImage.compressedImage), UIImage.data(from: decodedImage.wrappedValue))
    }
    
    func testCodableOptionalColor() {
        let optionalColor = CodableValue(wrappedValue: UIColor.init(red: 1, green: 1, blue: 1, alpha: 1) as UIColor?)
        
        XCTAssertNoThrow(try encoder.encode(optionalColor))
        
        let encoded = try! encoder.encode(optionalColor)
        
        XCTAssertNoThrow(try decoder.decode(CodableValue<UIColor?>.self, from: encoded))
        let decodedOptionalColor = try! decoder.decode(CodableValue<UIColor?>.self, from: encoded)
        
        XCTAssertEqual(optionalColor, decodedOptionalColor)
    }
    
    func testCodableOptionalNilColor() {
        let optionalColor = CodableValue(wrappedValue: nil as UIColor?)
        
        XCTAssertNoThrow(try encoder.encode(optionalColor))
        let encoded = try! encoder.encode(optionalColor)

        XCTAssertThrowsError(try decoder.decode(CodableValue<UIColor>.self, from: encoded))
        XCTAssertNoThrow(try decoder.decode(CodableValue<UIColor?>.self, from: encoded))
        
    }
    
    func testCodableNonOptionalColor() {
        let color = CodableValue(wrappedValue: UIColor.init(red: 1, green: 1, blue: 1, alpha: 1))
        
        XCTAssertNoThrow(try encoder.encode(color))
        
        let encoded = try! encoder.encode(color)
        XCTAssertNoThrow(try decoder.decode(CodableValue<UIColor>.self, from: encoded))
        let decodedColor = try! decoder.decode(CodableValue<UIColor>.self, from: encoded)
        
        XCTAssertEqual(color, decodedColor)
        print(String(data: encoded, encoding: .utf8)!)
    }
}

extension CodableValueTests {
    private enum TestImage {
        static let image = UIImage(data: data)
        static let compressedImage = UIImage(data: UIImage.data(from: image)!)
        static let data = try! Data(contentsOf: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Swift_logo.svg/2880px-Swift_logo.png")!)
    }
}

#endif
