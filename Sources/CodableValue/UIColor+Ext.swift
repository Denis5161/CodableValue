//
//  UIColor+Ext.swift
//  
//
//  Created by Denis Goldberg on 20.04.22.
//

import UIKit

extension UIColor {
    ///Different color keys, provided in a type-safe way.
    enum ColorRGBA: String, Codable {
        case red, green, blue, alpha
    }
    
    ///Initialize a `UIColor` from a dictionary with `CGFloat` values.
    ///- Parameter dict: The dictionary holds its values with `UIColor.ColorRGBA` keys. The values range from `0.0` to `1.0`.
    convenience init(from dict: [UIColor.ColorRGBA : CGFloat]) {
        self.init(red: dict[.red]!, green: dict[.green]!, blue: dict[.blue]!, alpha: dict[.alpha]!)
    }
    
    ///Returns the components that make up the color in the RGB color space.
    var rgba: [UIColor.ColorRGBA : CGFloat] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return [.red: red, .green: green, .blue: blue, .alpha: alpha]
    }
}

extension UIColor: Encodable {
    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rgba)
        }
}
