//
//  NSImage+Ext.swift
//  
//
//  Created by Denis Goldberg on 22.04.22.
//

#if canImport(AppKit)

import AppKit

extension NSImage {
    
    ///Determines if NSImage encodes to JPEG. When set to `.png`, encodes a png file.
    ///
    ///- Note: This changes the encoded data for every UIImage.
    public static var encodingFileType: NSBitmapImageRep.FileType = .jpeg
    
    ///Returns the data representation for the Image.
    func data(for fileType: NSBitmapImageRep.FileTyp = encodingFileType) -> Data? {
        if let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil) {
            let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
            if let data = bitmapRep.representation(using: fileType, properties: [:]) {
                return data
            }
        }
        
        return nil
    }
}

extension NSImage: CodableValueSupported {
    public static let type = SupportedCodableTypes.image
    
    public func encode(to encoder: Encoder) throws {
        let imageData = data()
        var container = encoder.singleValueContainer()
        try container.encode(imageData)
    }
    
}
#endif
