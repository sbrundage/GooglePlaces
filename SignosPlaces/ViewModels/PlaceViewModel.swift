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
		if place.imageData == nil {
			getPlaceImage()
		}
		if place.phone == nil {
			getMoreDetails()
		}
	}
	
	func getPlace() -> Place { place }
	
	private func getPlaceImage() {
		guard let photoReference = place.photoReference else { return }
		GooglePlaceAPI.shared.getPicture(with: photoReference) { result in
			switch result {
				case .success(let imageData):
					self.place.imageData = imageData
					self.delegate?.updateCellInfo()
				case .failure(let error):
					print("Error during api call : \(error)")
			}
		}
	}
	
	private func getMoreDetails() {
		GooglePlaceAPI.shared.getPlaceDetails(placeId: place.placeId) { result in
			switch result {
				case .success(let responseModel):
					self.place.phone = responseModel.result.formatted_phone_number
				case .failure(let error):
					print("Error during api call: \(error)")
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
