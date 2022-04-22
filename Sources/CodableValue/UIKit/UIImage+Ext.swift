//
//  UIImage+Ext.swift
//  
//
//  Created by Denis Goldberg on 20.04.22.
//

#if canImport(UIKit)

import UIKit

extension UIImage: CodableValueSupported {
    public static let type = SupportedCodableTypes.image
    
    /// The File Types that UIImage can be encoded as.
    public enum EncodingFileType {
        case jpeg, png
    }
    
    ///Compression Quality to be used for compressing a UIImage to JPEG data. Change the compression quality if needed.
    ///
    ///- Note: This changes the compression quality for every UIImage jpeg.
    public static var compressionQuality: CGFloat = 0.3
    
    ///Determines which file type UIImage encodes to. When set to `.jpeg`, encodes a jpeg file.
    ///
    ///- Note: This changes the encoded data for every UIImage.
    public static var encodingFileType = EncodingFileType.jpeg
    
    ///Returns the UIImage either as png or jpegData
    ///- Note: When the file type is `.png` the compression quality is ignored.
    public func data(for fileType: EncodingFileType = encodingFileType, with compression: CGFloat = compressionQuality) -> Data? {
        switch fileType {
        case .jpeg:
            return jpegData(compressionQuality: compression)
        case .png:
            return pngData()
        }
    }

    public func encode(to encoder: Encoder) throws {
        let imageData = data()
        var container = encoder.singleValueContainer()
        try container.encode(imageData)
    }
}

#endif
