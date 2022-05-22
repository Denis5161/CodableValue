//
//  UIImage+Ext.swift
//  
//
//  Created by Denis Goldberg on 20.04.22.
//

#if canImport(UIKit)

import UIKit

extension UIImage {
    ///Returns the UIImage either as png or jpegData
    ///- Note: When the file type is `.png` the compression quality is ignored.
    static func data(from image: UIImage?, for fileType: ImageEncodingFileTypes = .jpeg, with compression: CGFloat = 0.3) -> Data? {
        switch fileType {
        case .jpeg:
            return image?.jpegData(compressionQuality: compression)
        case .png:
            return image?.pngData()
        }
    }


}

extension UIImage: CodableValueSupported {
    public static let type = SupportedCodableTypes.image
    
    public func encode(to encoder: Encoder) throws {
        let imageData = Self.data(from: self)
        var container = encoder.singleValueContainer()
        try container.encode(imageData)
    }  
}

#endif
