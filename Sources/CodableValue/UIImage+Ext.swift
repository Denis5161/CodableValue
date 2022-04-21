//
//  UIImage+Ext.swift
//  
//
//  Created by Denis Goldberg on 20.04.22.
//

import UIKit



extension UIImage: Encodable {
    ///Compression Quality to be used for compressing a UIImage to JPEG data.
    private enum CompressionQuality {
        static let standard: CGFloat = 0.3
    }
    
    public func encode(to encoder: Encoder) throws {
        if let imageData = self.jpegData(compressionQuality: CompressionQuality.standard) {
            var container = encoder.singleValueContainer()
            try container.encode(imageData)
        }
    }
}
