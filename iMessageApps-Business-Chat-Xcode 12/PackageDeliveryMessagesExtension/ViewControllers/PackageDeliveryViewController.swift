/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A `UIViewController` that display the package delivery status and allow the user to confirm the destination.
*/

import UIKit
import MapKit

class PackageDeliveryViewController: UIViewController {
    
    private let mapView = MKMapView()
    private let tableView = UITableView()
    private let confirmButton = UIButton()
    private let locationManager = CLLocationManager()
    private let packageInfoView: PackageInfoView
    private var tableViewHeightConstaint: NSLayoutConstraint!
    private var confirmButtonHeightConstaint: NSLayoutConstraint!
    weak private var delegate: PackageDeliveryMessageAppDelegate?
    
    fileprivate var isUpdatedForUserLocation = false
    fileprivate var destinations = [Destination] ()
    fileprivate var package: Package
    
    // MARK: Initializers
    
    init(package: Package, delegate: PackageDeliveryMessageAppDelegate) {
        self.delegate = delegate
        self.package = package
        self.packageInfoView = PackageInfoView(package:package)
        self.destinations.append(package.destination)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init with coder not implemented use init with package!")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.requestLocationAutorization()
        self.setupSubviews()
        self.setupConstraints()
        self.updateMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationManager.requestLocation()
        
        if package.destination.isFinal {
            tableView.delegate = nil
            tableView.dataSource = nil
            tableView.isHidden = true
            confirmButton.isHidden = true
            confirmButtonHeightConstaint.constant = 0
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewHeightConstaint.constant = tableView.contentSize.height
    }
    
    // MARK: Subviews configuration
    
    private func setupSubviews() {
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 40
        tableView.estimatedRowHeight = 75
        tableView.estimatedSectionHeaderHeight = 40
        
        confirmButton.setTitle("Confirm".uppercased(), for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmDelivery), for: .touchUpInside)
        confirmButton.setTitleColor(#colorLiteral(red:0.282352941176471, green:0.627450980392157, blue: 0.568627450980392, alpha: 1), for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        confirmButton.backgroundColor = #colorLiteral(red:0.941176470588235, green:0.941176470588235, blue: 0.941176470588235, alpha: 1)
        
        view.addSubview(mapView)
        view.addSubview(packageInfoView)
        view.addSubview(tableView)
        view.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        packageInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        // MapView Constraints
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // PackageInfo Constraints
        NSLayoutConstraint.activate([
            packageInfoView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            packageInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            packageInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // TableView Constraints
        tableViewHeightConstaint = tableView.heightAnchor.constraint(equalToConstant:100)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: packageInfoView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewHeightConstaint
        ])
        
        // Confirm Button Constraints
        confirmButtonHeightConstaint = confirmButton.heightAnchor.constraint(equalToConstant:60)
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            confirmButtonHeightConstaint
        ])
    }
    
    // MARK: Location Manager
    
    private func requestLocationAutorization() {
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: View Model Update
    
    fileprivate func updateCurrentLocationDestination(destination: Destination) {
        if destinations.count > 1 {
            destinations.removeLast()
        }
        destinations.append(destination)
        tableView.reloadData()
        
        // Animate table view growing/shrinking if needed
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    fileprivate func updateMap() {
        if !mapView.annotations.isEmpty {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        mapView.addAnnotation(package.destination.annotation)
        mapView.selectAnnotation(package.destination.annotation, animated: true)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    // MARK: Actions
    
    @objc
    func confirmDelivery() {
        package.destination.isFinal = true
        self.delegate?.sendReplyMessage(with: package)
    }
    
}

/**
 Extends `PackageDeliveryViewController` to conform to the `UITableViewDataSource`
 protocol.
 */
extension PackageDeliveryViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select Delivery Destination"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "destinationCell")
            ??  DestinationTableViewCell(style: .subtitle, reuseIdentifier: "destinationCell")
        configureCell(cell, for: destinations[indexPath.row])
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, for destination: Destination) {
        if let cell = cell as? DestinationTableViewCell {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currencyAccounting
            let priceString = numberFormatter.string(from: NSNumber(value: package.extraCharge)) ?? "Free"
            cell.textLabel?.text = destination.isMyLocation ? "My Current Location" : destination.name
            cell.priceLabel.text = destination.isMyLocation ? priceString : "Free"
            cell.detailTextLabel?.text = destination.formattedAddress
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.textColor = #colorLiteral(red:0, green:0, blue: 0, alpha: 0.5)
            cell.selectionStyle = .none
            
            if package.destination == destination {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
    }
}

/**
 Extends `PackageDeliveryViewController` to conform to the `UITableViewDelegate`
 protocol.
 */
extension PackageDeliveryViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDestination = destinations[indexPath.row]
        
        package.destination = selectedDestination
        tableView.reloadData()
        updateMap()
    }
    
}

/**
 Extends `PackageDeliveryViewController` to conform to the `MKMapViewDelegate`
 protocol.
 */
extension PackageDeliveryViewController:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: DestinationAnnotation.self) {
            return MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "destinationMarker")
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !isUpdatedForUserLocation {
            mapView.showAnnotations(mapView.annotations, animated: true)
            isUpdatedForUserLocation = true
        }
    }
}

/**
 Extends `PackageDeliveryViewController` to conform to the `CLLocationManagerDelegate`
 protocol.
 */
extension PackageDeliveryViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geocoder = CLGeocoder()
        
        if let location = locations.first {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Error Reverse Geocoding location: \(error)")
                    return
                }
                
                if let placemark = placemarks?.first, var destination = Destination(placemark: placemark) {
                    DispatchQueue.main.async {
                        destination.isMyLocation = true
                        self.updateCurrentLocationDestination(destination: destination)
                    }
                } else {
                    print("Invalid placemarks returned by geocoder: \(String(describing:placemarks))")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("Location manager failed with error \(error)")
    }
    
}
