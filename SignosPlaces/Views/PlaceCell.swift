//
//  PlaceCell.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/10/21.
//

import UIKit

protocol PlaceCellDelegate {
	func placeAdded(newPlaceVM: PlaceViewModel)
	func placeRemoved(place: Place)
}

class PlaceCell: UITableViewCell {

	@IBOutlet weak var placeImage: UIImageView!
	@IBOutlet weak var placeNameLabel: UILabel!
	@IBOutlet weak var placeAddressLabel: UILabel!
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var ratingLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var placeTypeLabel: UILabel!
	
	static let identifier = "PlaceCell"
	static let nib = UINib(nibName: identifier, bundle: nil)
	
	private var viewModel: PlaceViewModel? {
		didSet {
			setupCell()
		}
	}
	
	var delegate: PlaceCellDelegate?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        styleCell()
    }
	
	public func initializePlaceCell(with viewModel: PlaceViewModel) {
		self.viewModel = viewModel
		self.viewModel?.delegate = self
		setupCell()
	}
	
	private func setupCell() {
		updateInfo()
		updateButton()
	}
	
	private func updateInfo() {
		guard let place = viewModel?.getPlace() else { return }
		placeNameLabel.text = place.name
		placeAddressLabel.text = place.address
		ratingLabel.text = "\(place.rating) / 5"
		placeImage.image = place.image ?? UIImage(systemName: "square.split.diagonal.2x2")
		placeTypeLabel.text = place.determinedType?.rawValue
	}
	
	private func updateButton() {
		guard let place = viewModel?.getPlace() else { return }
		addButton.isEnabled = !place.isSaved
		addButton.backgroundColor = place.isSaved ? .gray : .systemGreen
		place.isSaved ? addButton.setTitle("Added", for: .disabled) :
			addButton.setTitle("Add", for: .normal)
	}
    
	private func styleCell() {
		addButton.layer.cornerRadius = 10
		placeImage.layer.cornerRadius = 10
	}
	
	@IBAction func addButtonClicked(_ sender: Any) {
		guard let placeVM = viewModel else { return }
		placeVM.savePlace()
		updateButton()
		delegate?.placeAdded(newPlaceVM: placeVM)
	}
	
}

extension PlaceCell: PlaceViewModelDelegate {
	func updateCellInfo() {
		DispatchQueue.main.async {
			self.updateInfo()
		}
	}
}
