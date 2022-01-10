/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Package Information view used to display package name, delivery date and icon
*/

import UIKit

class PackageInfoView: UIView {

    let captionLabel = UILabel()
    let subcaptionLabel = UILabel()
    
    private let iconImageView = UIImageView()
    private let captionBackground = UIView()
    private let package: Package?
    
    // MARK: Initializer
    
    init(package: Package?) {
        self.package = package
        super.init(frame: .zero)
        
        setupSubviews()
        setupConstraints()
        updateContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init with coder not implemented use init with Package!")
    }
    
    // MARK: Subviews configuration
    
    private func setupSubviews() {
        preservesSuperviewLayoutMargins = true
        captionBackground.backgroundColor = #colorLiteral(red:0.0705, green:0.698, blue: 0.588, alpha: 1)
        iconImageView.image = #imageLiteral(resourceName: "BoxIcon")
        
        captionLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        captionLabel.numberOfLines = 2
        captionLabel.textColor = .white
        
        subcaptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subcaptionLabel.textColor = .white
        subcaptionLabel.numberOfLines = 2
        subcaptionLabel.alpha = 0.66
        
        addSubview(captionBackground)
        addSubview(iconImageView)
        addSubview(captionLabel)
        addSubview(subcaptionLabel)
    }
    
    private func setupConstraints() {
        captionBackground.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        subcaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            captionBackground.topAnchor.constraint(equalTo: topAnchor),
            captionBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            captionBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            captionBackground.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            captionLabel.topAnchor.constraint(equalTo: topAnchor, constant:16),
            captionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            captionLabel.trailingAnchor.constraint(lessThanOrEqualTo: iconImageView.leadingAnchor, constant:12)
        ])
        
        NSLayoutConstraint.activate([
            subcaptionLabel.topAnchor.constraint(equalTo: captionLabel.lastBaselineAnchor, constant:5),
            subcaptionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            subcaptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: iconImageView.leadingAnchor, constant:12),
            subcaptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant:-16)
        ])
    }
    
    // MARK: Content update
    
    func updateContent() {
        if let package = package {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
            
            if package.destination.isFinal {
                captionLabel.text = package.destination.isMyLocation ? "My Current Location" : package.destination.name
                subcaptionLabel.text = package.destination.formattedAddress
            } else {
                captionLabel.text = package.name
                subcaptionLabel.text = "Scheduled for Delivery - \(dateFormatter.string(from: package.deliveryDate))"
            }
            
        } else {
            captionLabel.text = "Invalid Package"
        }
    }
}

