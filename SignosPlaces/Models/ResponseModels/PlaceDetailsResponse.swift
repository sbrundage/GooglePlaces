//
//  PlaceDetailsResponse.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/11/21.
//

import Foundation

struct PlaceDetailsResponse: Decodable {
	let result: PlaceDetails
}

struct PlaceDetails: Decodable {
	let formatted_phone_number: String
}
