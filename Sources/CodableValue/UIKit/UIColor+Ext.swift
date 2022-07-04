//
//  UIColor+Ext.swift
//  
//
//  Created by Denis Goldberg on 20.04.22.
//

#if canImport(UIKit)

import UIKit

extension UIColor: CodableValueSupported {
    public static let type = SupportedCodableTypes.color
}

#endif
