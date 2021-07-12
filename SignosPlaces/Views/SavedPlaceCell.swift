//
//  SavedPlaceCell.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/12/21.
//

import UIKit

class SavedPlaceCell: UITableViewCell {

	@IBOutlet weak var placeNameLabel: UILabel!
	@IBOutlet weak var placeAddressLabel: UILabel!
	@IBOutlet weak var placePhoneLabel: UILabel!
	
	static let identifier = "SavedPlaceCell"
	static let nib = UINib(nibName: identifier, bundle: nil)
	
	var place: Place? {
		didSet {
			setupCell()
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		setupGestureRecognizers()
	}
    
	private func setupCell() {
		guard let place = place else { return }
		placeNameLabel.text = place.name
		placeAddressLabel.text = place.address
		placePhoneLabel.text = place.phone
	}
	
	private func setupGestureRecognizers() {
		let labelTap = UITapGestureRecognizer(target: self, action: #selector(callPhoneNumber(_:)))
		placePhoneLabel.isUserInteractionEnabled = true
		placePhoneLabel.addGestureRecognizer(labelTap)
	}
	
	@objc private func callPhoneNumber(_ sender: UITapGestureRecognizer) {
		guard let phoneNumber = place?.phone else { return }
		if let url = URL(string: "tel://\(phoneNumber)"),
		   UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
}
