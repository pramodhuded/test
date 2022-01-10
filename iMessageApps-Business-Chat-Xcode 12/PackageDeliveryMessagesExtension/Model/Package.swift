/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Defines the `Package` struct that represents a package to be delivered.
*/

import Foundation
import CoreLocation
import Intents

struct Package {
    
    private struct Key {
        static let name = "name"
        static let extraCharge = "extraCharge"
        static let date = "deliveryDate"
    }
    
    let name: String
    let deliveryDate: Date
    let extraCharge: Double
    var destination: Destination
    private let dateFormatter = DateFormatter()
    
    // MARK: Initializer
    
    init(url: URL) throws {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        var queryItems = [String: String]()
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        for queryItem in (urlComponents?.queryItems)! {
            queryItems[queryItem.name] = queryItem.value
        }
        
        guard let name = queryItems[Key.name] else {
            throw KeyError.missing(Key.name)
        }
        
        guard let deliveryDateString = queryItems[Key.date], let deliveryDate = dateFormatter.date(from: deliveryDateString) else {
            throw KeyError.missing(Key.date)
        }
        
        guard let extraChargeString = queryItems[Key.extraCharge], let extraCharge = Double(extraChargeString) else {
            throw KeyError.missing(Key.extraCharge)
        }
        
        self.name = name
        self.extraCharge = extraCharge
        self.deliveryDate = deliveryDate
        self.destination = try Destination(dictionary:queryItems)
    }
    
    var queryItems: [URLQueryItem] {
        var items = [
            URLQueryItem(name: Key.name, value: name),
            URLQueryItem(name: Key.extraCharge, value: String(extraCharge)),
            URLQueryItem(name: Key.date, value: dateFormatter.string(from: deliveryDate))
        ]
        items.append(contentsOf: destination.queryItems)
        return items
    }
}

