//
//  UIImage+Ext.swift
//  
//
//  Created by Denis Goldberg on 20.04.22.
//

import UIKit

extension UIImage: Encodable {
    public func encode(to encoder: Encoder) throws {
        
        if let imageData = pngData() {
            var container = encoder.singleValueContainer()
            try container.encode(imageData)
        }
    }
}
