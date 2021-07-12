//
//  SearchPlaceRequest.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/10/21.
//

import Foundation

struct SearchPlaceRequest: ApiRequest {
	
	typealias ModelType = SearchTextPlaceResponse
	
	var baseURL: String = Endpoints.placeSearch.rawValue
	var method: HTTPMethod = .get
	var parameters: [String : String]?
	
	init(searchText: String) {
		parameters = [
			"query": searchText,
			"type": PlaceType.gym.rawValue + "," +
				PlaceType.restaurant.rawValue + "," +
				PlaceType.supermarket.rawValue + "," +
				PlaceType.food.rawValue,
			"key": APIKey.googlePlaces.rawValue
		]
	}
}
