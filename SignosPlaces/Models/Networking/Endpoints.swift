//
//  Endpoints.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/10/21.
//

import Foundation

enum Endpoints: String {
	case placeSearch = "https://maps.googleapis.com/maps/api/place/textsearch/json"
	case placePhoto = "https://maps.googleapis.com/maps/api/place/photo"
}

enum HTTPMethod: String {
	case get = "GET"
}
