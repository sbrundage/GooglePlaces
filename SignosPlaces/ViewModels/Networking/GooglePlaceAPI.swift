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
}
