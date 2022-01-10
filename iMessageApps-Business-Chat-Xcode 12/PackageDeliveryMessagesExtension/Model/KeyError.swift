/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A custom `Error` type to report missing or invalid keys.
*/

import Foundation

enum KeyError: Error, CustomDebugStringConvertible {
    case missing(String)
    case invalid(String)
    
    var debugDescription: String {
        switch self {
        case let .missing(key): return "Missing key '\(key)'."
        case let .invalid(key): return "Invalid key '\(key)'."
        }
    }
}
