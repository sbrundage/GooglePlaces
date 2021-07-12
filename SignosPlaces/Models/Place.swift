//
//  Place.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/10/21.
//

import UIKit

struct Place: Codable {
	let name: String
	let address: String
	var imageData: Data?
	var phone: String?
	let types: [PlaceType]
	let determinedType: PlaceType?
	let rating: Double
	let placeId: String
	var isOpened: Bool = false
	var isSaved: Bool = false
	let photoReference: String?
	
	init(placeResponse: PlaceResponse) {
		self.name = placeResponse.name
		self.address = placeResponse.formatted_address
		self.types = placeResponse.types
		self.rating = placeResponse.rating
		self.placeId = placeResponse.place_id
		self.imageData = nil
		self.phone = nil
		self.determinedType = types.filter { $0 != .other }.first
		self.photoReference = placeResponse.photos?.first?.photo_reference
	}
	
	func getImage() -> UIImage? {
		imageData != nil ? UIImage(data: imageData!) : nil
	}
}
