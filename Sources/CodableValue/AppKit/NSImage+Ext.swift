//
//  NSImage+Ext.swift
//  
//
//  Created by Denis Goldberg on 22.04.22.
//

#if canImport(AppKit)

import AppKit

extension NSImage {
    
    ///Returns the data representation for the image.
    static func data(from image: NSImage?, for fileType: ImageEncodingFileTypes = .jpeg) -> Data? {
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

extension NSImage: CodableValueSupported {
    public static let type = SupportedCodableTypes.image
    
    public func encode(to encoder: Encoder) throws {
        preconditionFailure("This function should not be called directly. Use the CodableValue property wrapper to encode and decode images.")
    }
    
}
#endif
