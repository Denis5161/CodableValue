//
//  UIImage+Ext.swift
//  
//
//  Created by Denis Goldberg on 20.04.22.
//

import UIKit

extension UIImage: CodableValueSupported {
    public static let type = SupportedCodableTypes.image
    
    ///Compression Quality to be used for compressing a UIImage to JPEG data. Change the compression quality if needed.
    ///
    ///- Note: This changes the compression quality for every UIImage.
    public static var compressionQuality: CGFloat = 0.3
    
    ///Determines if UIImage encodes to JPEG. When set to `false`, encodes a png file.
    ///
    ///- Note: This changes the encoded data for every UIImage.
    public static var encodesToJPEG               = true

    public func encode(to encoder: Encoder) throws {
        if let imageData = Self.encodesToJPEG ? jpegData(compressionQuality: Self.compressionQuality) : pngData() {
            var container = encoder.singleValueContainer()
            try container.encode(imageData)
        }
    }
}
