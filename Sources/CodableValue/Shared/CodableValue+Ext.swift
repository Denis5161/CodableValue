//
//  CodableValue+Ext.swift
//  
//
//  Created by Denis Goldberg on 27.04.22.
//

/// The file types that an image can be encoded into.
public enum ImageEncodingFileTypes {
    case jpeg, png
}
 
#if canImport(UIKit)
import UIKit

extension CodableValue where T == UIImage {
    ///Initializes `CodableValue`.
    ///
    ///This initializer enables encoding of different types of image file types (jpeg, png). When setting the encoding to png, the compression quality parameter is ignored.
    ///
    ///- Parameters:
    ///     - wrappedValue: The wrapped value must be a UIImage.
    ///     - fileType: The desired file type of the encoded image. Default is jpeg.
    ///     - jpegCompressionQuality: When the file type is .jpeg, set a compression quality. Default is 0.3. Ignored when using `fileType: .png'
    public init(wrappedValue: T, encodesTo fileType: ImageEncodingFileTypes = .jpeg, withCompression jpegCompressionQuality: CGFloat = 0.3) {
        self.wrappedValue               = wrappedValue
        self.imageEncodingFileType      = fileType
        self.imageEncodingCompression   = jpegCompressionQuality
    }
}

extension CodableValue where T == UIImage? {
    ///Initializes `CodableValue`.
    ///
    ///This initializer enables encoding of different types of image file types (jpeg, png). When setting the encoding to png, the compression quality parameter is ignored.
    ///
    ///- Parameters:
    ///     - wrappedValue: The wrapped value must be a UIImage.
    ///     - fileType: The desired file type of the encoded image. Default is jpeg.
    ///     - jpegCompressionQuality: When the file type is .jpeg, set a compression quality. Default is 0.3. Ignored when using `fileType: .png'
    public init(wrappedValue: T, encodesTo fileType: ImageEncodingFileTypes = .jpeg, withCompression jpegCompressionQuality: CGFloat = 0.3) {
        self.wrappedValue               = wrappedValue
        self.imageEncodingFileType      = fileType
        self.imageEncodingCompression   = jpegCompressionQuality
    }
}

#elseif canImport(AppKit)
import AppKit

extension CodableValue where T: NSImage {
    ///Initializes `CodableValue`.
    ///
    ///This initializer enables encoding of different types of image file types (jpeg, png).
    ///
    ///- Parameters:
    ///     - wrappedValue: The wrapped value must be a UIImage.
    ///     - fileType: The desired file type of the encoded image. Default is jpeg.
    public init(wrappedValue: T, encodesTo fileType: ImageEncodingFileTypes) {
        self.wrappedValue               = wrappedValue
        self.imageEncodingFileType      = fileType
    }
}

extension CodableValue where T == NSImage? {
    ///Initializes `CodableValue`.
    ///
    ///This initializer enables encoding of different types of image file types (jpeg, png).
    ///
    ///- Parameters:
    ///     - wrappedValue: The wrapped value must be a UIImage.
    ///     - fileType: The desired file type of the encoded image. Default is jpeg.
    public init(wrappedValue: T, encodesTo fileType: ImageEncodingFileTypes) {
        self.wrappedValue               = wrappedValue
        self.imageEncodingFileType      = fileType
    }
}
#endif
