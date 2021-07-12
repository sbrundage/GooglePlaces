//
//  PlaceType.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/10/21.
//

import Foundation

enum PlaceType: String {
	case gym
	case restaurant
	case supermarket
	case food
	//	case cafe
//	case mealDelivery = "meal_delivery"
//	case mealTakeaway = "meal_takeaway"
	case other
}

extension PlaceType: Codable {
	init(from decoder: Decoder) throws {
		self = try PlaceType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .other
	}
}
