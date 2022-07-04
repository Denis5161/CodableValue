//
//  NSColor+Ext.swift
//  
//
//  Created by Denis Goldberg on 22.04.22.
//

#if canImport(AppKit)

import AppKit

extension NSColor: CodableValueSupported {
    public static let type = SupportedCodableTypes.color
}

#endif
