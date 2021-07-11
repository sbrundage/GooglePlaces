//
//  SearchPlaceResponse.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/10/21.
//

import Foundation

struct SearchTextPlaceResponse: Decodable {
	let results: [PlaceResponse]
}

struct PlaceResponse: Decodable {
	let formatted_address: String
	let name: String
	let photos: [PhotoResponse]?
	let place_id: String
	let rating: Double
	let types: [PlaceType]
}

struct PhotoResponse: Decodable {
	let photo_reference: String
}
