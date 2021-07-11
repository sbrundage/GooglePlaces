//
//  PlaceCell.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/10/21.
//

import UIKit

protocol PlaceCellDelegate {
	func placeAdded(newPlace: Place)
	func placeRemoved(place: Place)
}

class PlaceCell: UITableViewCell {

	@IBOutlet weak var placeNameLabel: UILabel!
	@IBOutlet weak var placeAddressLabel: UILabel!
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var ratingLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	
	static let identifier = "PlaceCell"
	static let nib = UINib(nibName: identifier, bundle: nil)
	
	var delegate: PlaceCellDelegate?
	
	var place: Place? {
		didSet {
			setupCell()
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        styleCell()
    }
	
	private func setupCell() {
		guard let place = place else { return }
		placeNameLabel.text = place.name
		placeAddressLabel.text = place.address
		ratingLabel.text = "Rating: \(place.rating) / 5"
		updateButton()
	}
	
	private func updateButton() {
		guard let place = place else { return }
		addButton.isEnabled = !place.isSaved
		addButton.backgroundColor = place.isSaved ? .gray : .systemGreen
		place.isSaved ? addButton.setTitle("Added", for: .disabled) :
			addButton.setTitle("Add", for: .normal)
	}
    
	private func styleCell() {
		addButton.layer.cornerRadius = 5
	}
	
	@IBAction func addButtonClicked(_ sender: Any) {
		guard let place = place else { return }
		place.isSaved.toggle()
		updateButton()
		delegate?.placeAdded(newPlace: place)
	}
	
}
