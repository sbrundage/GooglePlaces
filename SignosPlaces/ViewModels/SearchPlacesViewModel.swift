//
//  SearchPlacesViewModel.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/10/21.
//

import Foundation

protocol GoogleSearchPlacesDelegate: AnyObject {
	func searchResultsFound()
	func errorWhileSearching(error: Error)
}

class SearchPlacesViewModel {
	
	weak var delegate: GoogleSearchPlacesDelegate?
	
	var placeViewModels: [PlaceViewModel] = [] {
		didSet {
			delegate?.searchResultsFound()
		}
	}
	
	func searchForPlaces(with text: String) {
		GooglePlaceAPI.shared.searchGymFoodGroceryPlaces(with: text) { result in
			switch result {
				case .success(let responseModel):
					self.placeViewModels = responseModel.results.map { PlaceViewModel(place: Place(placeResponse: $0)) }
				case .failure(let error):
					self.delegate?.errorWhileSearching(error: error)
			}
		}
	}
}
