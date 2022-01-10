/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Defines the `Destination` struct that represents a package's destination.
*/

import Foundation
import CoreLocation

struct Destination {
    
    private struct Key {
        static let destination = "destinationName"
        static let street = "street"
        static let state = "state"
        static let city = "city"
        static let country = "country"
        static let postalCode = "postalCode"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let myLocation = "isMyLocation"
        static let finalDestination = "isFinalDestination"
    }
    
    var name: String
    var annotation: DestinationAnnotation
    let street: String
    let city: String
    let state: String
    let country: String
    let postalCode: String
    var isMyLocation = false
    var isFinal = false
    
    var formattedAddress: String {
        return "\(street), \(city)\n\(state), \(country), \(postalCode)"
    }
    
    // MARK: Initializer
    
    init(dictionary: [String: String]) throws {
        guard let destinationName = dictionary[Key.destination] else {
            throw KeyError.missing(Key.destination)
        }
        
        guard let street = dictionary[Key.street] else {
            throw KeyError.missing(Key.street)
        }
        
        guard let city = dictionary[Key.city] else {
            throw KeyError.missing(Key.city)
        }
        
        guard let state = dictionary[Key.state] else {
            throw KeyError.missing(Key.state)
        }
        
        guard let country = dictionary[Key.country] else {
            throw KeyError.missing(Key.country)
        }
        
        guard let postalCode = dictionary[Key.postalCode]  else {
            throw KeyError.missing(Key.postalCode)
        }
        
        guard let latitudeString = dictionary[Key.latitude], let latitude = Double(latitudeString) else {
            throw KeyError.missing(Key.latitude)
        }
        
        guard let longitudeString = dictionary[Key.longitude], let longitude = Double(longitudeString) else {
            throw KeyError.missing(Key.longitude)
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        guard CLLocationCoordinate2DIsValid(coordinate) else {
            throw KeyError.invalid("\(coordinate)")
        }
         
        self.annotation = DestinationAnnotation(with: coordinate, title: destinationName)
        self.name = destinationName
        self.street = street
        self.city = city
        self.state = state
        self.country = country
        self.postalCode = postalCode
        self.isMyLocation = dictionary[Key.myLocation] == "true" ? true : false
        self.isFinal = dictionary[Key.finalDestination] == "true" ? true : false
    }
    
    var queryItems: [URLQueryItem] {
        return [
            URLQueryItem(name: Key.destination, value: name),
            URLQueryItem(name: Key.street, value: street),
            URLQueryItem(name: Key.city, value: city),
            URLQueryItem(name: Key.state, value: state),
            URLQueryItem(name: Key.country, value: country),
            URLQueryItem(name: Key.postalCode, value: postalCode),
            URLQueryItem(name: Key.latitude, value: String(annotation.coordinate.latitude)),
            URLQueryItem(name: Key.longitude, value: String(annotation.coordinate.longitude)),
            URLQueryItem(name: Key.myLocation, value: String(isMyLocation)),
            URLQueryItem(name: Key.finalDestination, value: String(isFinal)),
        ]
    }
}

/**
 Extends `Destination` to be able to be created with the contents of an `Placemark`.
 */
extension Destination {
    init?(placemark: CLPlacemark) {
        guard let coordinate = placemark.location?.coordinate else {
            print("Failed to create destination, coordinate invalid for placemark")
            return nil
        }
        
        var street = ""
        if let subThoroughfare = placemark.subThoroughfare, let thoroughfare = placemark.thoroughfare {
            street =  "\(subThoroughfare) \(thoroughfare)"
        }
        
        self.annotation = DestinationAnnotation(with: coordinate, title: (placemark.name ?? ""))
        self.name = placemark.name ?? ""
        self.street = street
        self.city = placemark.locality ?? ""
        self.state = placemark.administrativeArea ?? ""
        self.country = placemark.country ?? ""
        self.postalCode = placemark.postalCode ?? ""
    }
}

/**
 Extends `Destination` to make it `Equatable`.
 */
extension Destination: Equatable {}
func ==(lhs: Destination, rhs: Destination) -> Bool {
    return lhs.name == rhs.name && lhs.street == rhs.street && lhs.city == rhs.city &&
        lhs.state == rhs.state && lhs.country == rhs.country && lhs.postalCode == rhs.postalCode
}

