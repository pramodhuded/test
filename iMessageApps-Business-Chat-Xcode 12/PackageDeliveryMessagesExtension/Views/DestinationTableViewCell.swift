/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Destination table view cell to display destination name and address
*/


import UIKit

class DestinationTableViewCell: UITableViewCell {
    
    let priceLabel = UILabel()
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init with coder not implemented use init with Package!")
    }
    
    // MARK: Subviews configuration
    
    private func setupSubviews() {
        priceLabel.textColor = .lightGray
        priceLabel.textAlignment = .right
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            priceLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 50)
        ])
    }
}
