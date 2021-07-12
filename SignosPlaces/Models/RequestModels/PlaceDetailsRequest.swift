//
//  PlaceDetailsRequest.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/11/21.
//

import Foundation

struct PlaceDetailsRequest: ApiRequest {
	typealias ModelType = PlaceDetailsResponse
	
	var baseURL: String = Endpoints.placeDetails.rawValue
	var method: HTTPMethod = .get
	var parameters: [String : String]?
	
	init(placeId: String) {
		parameters = [
			"place_id": placeId,
			"key": APIKey.googlePlaces.rawValue
		]
	}
}
