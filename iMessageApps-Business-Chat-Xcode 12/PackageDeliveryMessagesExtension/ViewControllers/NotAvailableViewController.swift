/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A `UIViewController` that warn the user that there is no package selected.
*/

import UIKit

class NotAvailableViewController: UIViewController {
    
    var canExpand = false
    weak private var delegate: PackageDeliveryMessageAppDelegate?
    private let iconImageView = UIImageView()
    private let warningLabel = UILabel()
    private let expandButton = UIButton()
    
    // MARK: Initializers
    
    init(delegate: PackageDeliveryMessageAppDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init with coder not implemented use init with delegate!")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.setupConstraints()
    }
    
    // MARK: Subviews configuration
    
    private func setupSubviews() {
        view.backgroundColor = #colorLiteral(red:0.5215686275, green:0.5294117647, blue: 0.5725490196, alpha: 1)
        
        warningLabel.text = "No Package Selected"
        warningLabel.textAlignment = .center
        warningLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        warningLabel.textColor = #colorLiteral(red:0.3137254902, green:0.3176470588, blue: 0.3411764706, alpha: 1)
        
        iconImageView.image = canExpand ? nil : #imageLiteral(resourceName: "InvalidPackageIcon")
        
        expandButton.setTitle("Show Delivery Options", for: .normal)
        expandButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        expandButton.setTitleColor(.white, for: .normal)
        expandButton.addTarget(self, action: #selector(expand), for: .touchUpInside)
        expandButton.backgroundColor = #colorLiteral(red:0.0705, green:0.698, blue: 0.588, alpha: 1)
        expandButton.layer.cornerRadius = 8
        expandButton.layer.masksToBounds = true
        
        iconImageView.isHidden = canExpand
        warningLabel.isHidden = canExpand
        expandButton.isHidden = !canExpand
        
        view.addSubview(iconImageView)
        view.addSubview(warningLabel)
        view.addSubview(expandButton)
    }
    
    private func setupConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon ImageView Constraints
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-15)
        ])
        
        // Warning Label Constraints
        NSLayoutConstraint.activate([
            warningLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant:15),
            warningLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        // Expand Button Constraints
        NSLayoutConstraint.activate([
            expandButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            expandButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            expandButton.heightAnchor.constraint(equalToConstant: 60),
            expandButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66)
        ])
    }
    
    @objc
    func expand() {
        delegate?.requestExpandedState()
    }

}
