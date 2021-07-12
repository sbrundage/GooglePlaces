//
//  GooglePlaceAPI.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/10/21.
//

import Foundation

class GooglePlaceAPI: NetworkManager {
	
	static let shared = GooglePlaceAPI()
	
	private override init() {}
	
	func searchGymFoodGroceryPlaces(with text: String, completion: @escaping WebServiceResult<SearchPlaceRequest.ModelType>) {
		let searchRequest = SearchPlaceRequest(searchText: text)
		guard let urlRequest = searchRequest.createURLRequest() else {
			completion(.failure(.invalidURL("Could not create url request for searchForPlaces api call")))
			return
		}
		
		performRequestForDecodable(urlRequest) { result in
			completion(result)
		}
	}
	
	func getPicture(with photoReference: String, completion: @escaping WebServiceResult<PlacePhotoRequest.ModelType>) {
		let photoRequest = PlacePhotoRequest(photoReference: photoReference, maxPhotoHeight: 100, maxPhotoWidth: 100)
		guard let urlRequest = photoRequest.createURLRequest() else {
			completion(.failure(.invalidURL("Could not create url request for PlacePhotoRequest")))
			return
		}
		
		performRequestForImage(urlRequest) { result in
			completion(result)
		}
	}
	
	func getPlaceDetails(placeId: String, completion: @escaping WebServiceResult<PlaceDetailsRequest.ModelType>) {
		let detailsRequest = PlaceDetailsRequest(placeId: placeId)
		guard let urlRequest = detailsRequest.createURLRequest() else {
			completion(.failure(.invalidURL("Could not create url request for PlaceDetailsRequest")))
			return
		}
		
		performRequestForDecodable(urlRequest) { result in
			completion(result)
		}
	}
}
