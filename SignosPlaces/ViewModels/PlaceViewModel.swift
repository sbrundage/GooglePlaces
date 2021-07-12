//
//  PlaceViewModel.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/11/21.
//

import UIKit

protocol PlaceViewModelDelegate {
	func updateCellInfo()
}

class PlaceViewModel {
	
	private var place: Place
	var delegate: PlaceViewModelDelegate?
	
	init(place: Place) {
		self.place = place
		getPlaceImage()
	}
	
	func getPlace() -> Place { place }
	
	private func getPlaceImage() {
		guard let photoReference = place.photoReference else { return }
		GooglePlaceAPI.shared.getPicture(with: photoReference) { result in
			switch result {
				case .success(let imageData):
					if let image = UIImage(data: imageData) {
						self.place.image = image
						self.delegate?.updateCellInfo()
					} else {
						print("Could not create uiimage from image data")
					}
				case .failure(let error):
					print("Error during api call : \(error)")
			}
		}
	}
	
	func toggleIsExpanded() {
		place.isOpened.toggle()
	}
	
	func savePlace() {
		place.isSaved = true
	}
}
