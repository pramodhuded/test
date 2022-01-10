/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Bubble view used to display information in the transcript
*/

import UIKit
import MapKit

class PackageDeliveryBubbleView: UIView {
    
    let packageImage = UIImageView()
    let packageInfo: PackageInfoView
    let package: Package?
    
    // MARK: Initializers
    
    init(package: Package?) {
        self.package = package
        self.packageInfo = PackageInfoView(package:package)
        super.init(frame: .zero)
        
        setupSubviews()
        setupConstraints()
        generateMapSnapshot()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init with coder not implemented use init with Package!")
    }
    
    // MARK: Subviews configuration
    
    private func setupSubviews() {
        preservesSuperviewLayoutMargins = true
        packageImage.contentMode = .scaleAspectFill
        addSubview(packageImage)
        addSubview(packageInfo)
    }
    
    private func setupConstraints() {
        packageImage.translatesAutoresizingMaskIntoConstraints = false
        packageInfo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            packageImage.topAnchor.constraint(equalTo: topAnchor),
            packageImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            packageImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            packageImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            packageInfo.leadingAnchor.constraint(equalTo: leadingAnchor),
            packageInfo.trailingAnchor.constraint(equalTo: trailingAnchor),
            packageInfo.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: Mapping
    
    private func generateMapSnapshot() {
        if let package = package {
            let options = snapshotOptionsForCoordinate(coordinate: package.destination.annotation.coordinate)
            let snapshotter = MKMapSnapshotter(options: options)
            snapshotter.start(completionHandler: { (snapshot, error) in
                if let error = error {
                    self.packageImage.image = #imageLiteral(resourceName: "InvalidPackage")
                    print("Error generating map snapshot: \(error)")
                    return
                }
                if let snapshot = snapshot {
                    self.packageImage.image = self.markedMapImage(for: snapshot, centerCoordinate: options.camera.centerCoordinate)
                }
            })
        } else {
            packageImage.image = #imageLiteral(resourceName: "InvalidPackage")
        }
    }
    
    private func snapshotOptionsForCoordinate(coordinate: CLLocationCoordinate2D) -> MKMapSnapshotter.Options {
        let options = MKMapSnapshotter.Options()
        let centerCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude - 0.001, longitude: coordinate.longitude)
        options.camera = MKMapCamera(lookingAtCenter: centerCoordinate, fromDistance: 800, pitch: 10, heading: 0)
        options.size = .init(width: 300, height: 210)
        
        return options
    }
    
    private func markedMapImage(for snapshot: MKMapSnapshotter.Snapshot, centerCoordinate: CLLocationCoordinate2D) -> UIImage? {
        let markerAnnotation = MKPointAnnotation()
        let markerView = MKMarkerAnnotationView(annotation: markerAnnotation, reuseIdentifier: "destinationMarker")
        let markerViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: snapshot.image.size.width, height: snapshot.image.size.height))
        var point = snapshot.point(for: centerCoordinate)
        point.x -= markerView.bounds.size.width / 2
        point.y -= markerView.bounds.size.height / 2
        point.y -= self.packageInfo.bounds.size.height / 2
        
        markerView.frame = CGRect(x: point.x, y: point.y, width: markerView.bounds.size.width, height: markerView.bounds.size.height)
        markerViewContainer.addSubview(markerView)
        
        UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, 0)
        snapshot.image.draw(at: .zero)
        markerViewContainer.drawHierarchy(in: CGRect.init(x: 0, y: 0, width: snapshot.image.size.width, height: snapshot.image.size.height), afterScreenUpdates: true)
        let markedMapImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return markedMapImage
    }
}

