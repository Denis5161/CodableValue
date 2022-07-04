//
//  TestsAppKit.swift
//  
//
//  Created by Denis Goldberg on 22.04.22.
//

#if canImport(AppKit)

import XCTest
@testable import CodableValue

final class CodableValueTests: XCTestCase {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func testCodableOptionalImage() {
        let optionalImage = CodableValue(wrappedValue: TestImage.image)
    
        XCTAssertNoThrow(try encoder.encode(optionalImage))
        
        let encoded = try! encoder.encode(optionalImage)
        
        XCTAssertNoThrow(try decoder.decode(CodableValue<NSImage?>.self, from: encoded))
        let decodedOptionalImage = try! decoder.decode(CodableValue<NSImage?>.self, from: encoded)
        
        XCTAssertEqual(TestImage.imageData, TestImage.data(from: decodedOptionalImage.wrappedValue))
        
    }
    
    func testCodableOptionalNilImage() {
        let optionalImage = CodableValue(wrappedValue: nil as NSImage?)
        
        XCTAssertNoThrow(try encoder.encode(optionalImage))
        
        let encoded = try! encoder.encode(optionalImage)
        
        XCTAssertThrowsError(try decoder.decode(CodableValue<NSImage>.self, from: encoded))
        XCTAssertNoThrow(try decoder.decode(CodableValue<NSImage?>.self, from: encoded))
        
    }
    
    func testCodableNonOptionalImage() {
        let image = CodableValue(wrappedValue: TestImage.image!)

        XCTAssertNoThrow(try encoder.encode(image))

        let encoded = try! encoder.encode(image)
        
        XCTAssertNoThrow(try decoder.decode(CodableValue<NSImage>.self, from: encoded))
        let decodedImage = try! decoder.decode(CodableValue<NSImage>.self, from: encoded)

        XCTAssertEqual(TestImage.imageData, TestImage.data(from: decodedImage.wrappedValue)!)
    }
    
    func testCodableOptionalColor() {
        let optionalColor = CodableValue(wrappedValue: NSColor.init(red: 1, green: 1, blue: 1, alpha: 1) as NSColor?)
        
        XCTAssertNoThrow(try encoder.encode(optionalColor))
        
        let encoded = try! encoder.encode(optionalColor)
        
        XCTAssertNoThrow(try decoder.decode(CodableValue<NSColor?>.self, from: encoded))
        let decodedOptionalColor = try! decoder.decode(CodableValue<NSColor?>.self, from: encoded)
        
        XCTAssertEqual(optionalColor, decodedOptionalColor)
    }
    
    func testCodableOptionalNilColor() {
        let optionalColor = CodableValue(wrappedValue: nil as NSColor?)
        
        XCTAssertNoThrow(try encoder.encode(optionalColor))
        let encoded = try! encoder.encode(optionalColor)

        XCTAssertThrowsError(try decoder.decode(CodableValue<NSColor>.self, from: encoded))
        XCTAssertNoThrow(try decoder.decode(CodableValue<NSColor?>.self, from: encoded))
        
    }
    
    func testCodableNonOptionalColor() {
        let color = CodableValue(wrappedValue: NSColor.init(red: 1, green: 1, blue: 1, alpha: 1))
        
        XCTAssertNoThrow(try encoder.encode(color))
        
        let encoded = try! encoder.encode(color)
        XCTAssertNoThrow(try decoder.decode(CodableValue<NSColor>.self, from: encoded))
        let decodedColor = try! decoder.decode(CodableValue<NSColor>.self, from: encoded)
        
        XCTAssertEqual(color, decodedColor)
    }
}

extension CodableValueTests {
    private enum TestImage {
        static let image = NSImage(data: data)
        static let imageData = data(from: image)
        static let data = try! Data(contentsOf: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Swift_logo.svg/2880px-Swift_logo.png")!)
        
        ///Returns the data representation for the image.
        fileprivate static func data(from image: NSImage?, for fileType: ImageEncodingFileTypes = .jpeg) -> Data? {
            if let cgImage = image?.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
                switch fileType {
                case .jpeg:
                    return bitmapRep.representation(using: .jpeg, properties: [:])
                case .png:
                    return bitmapRep.representation(using: .png, properties: [:])
                }
            }
            return nil
        }
    }
}

#endif
