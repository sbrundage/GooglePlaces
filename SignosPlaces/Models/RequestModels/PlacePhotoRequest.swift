//
//  PlacePhotoRequest.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/11/21.
//

import Foundation

struct PlacePhotoRequest: ApiRequest {
	typealias ModelType = Data
	
	var baseURL: String = Endpoints.placePhoto.rawValue
	var method: HTTPMethod = .get
	var parameters: [String : String]?
	
	init(photoReference: String, maxPhotoHeight: Int, maxPhotoWidth: Int) {
		parameters = [
			"photoreference": photoReference,
			"maxheight": "\(maxPhotoHeight)",
			"maxwidth": "\(maxPhotoWidth)",
			"key": APIKey.googlePlaces.rawValue
		]
	}
}
