//
//  DecodingValueError.swift
//  
//
//  Created by Denis Goldberg on 20.04.22.
//

import Foundation

///Throwable error value when `CodableValue` cannot decode the requested value.
public enum DecodingValueError<Base, Requested>: Error {
    ///When the type of the decoded value does not match the type of the requested value.
    case decodingTypeMismatch
    ///When a nil value is found, even though the requested value needs a non-optional value.
    case nonOptionalDecodingError
}

extension DecodingValueError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodingTypeMismatch:
            return "Mismatching types. Could not cast \(Base.self) to \(Requested.self)."
        case .nonOptionalDecodingError:
            return "No data for key. Could not decode non-optional type \(Requested.self)"
        }
    }
}
