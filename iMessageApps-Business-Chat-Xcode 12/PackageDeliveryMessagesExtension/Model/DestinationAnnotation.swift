/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Defines the `DestinationAnnotation` class representing an annotation to be added on map.
*/

import Foundation
import MapKit

class DestinationAnnotation: MKPointAnnotation {
    init(with coordinate: CLLocationCoordinate2D, title: String) {
        super.init()
        self.coordinate = coordinate
        self.title = title
    }
}
