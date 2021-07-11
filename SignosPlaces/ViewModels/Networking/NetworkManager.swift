//
//  NetworkManager.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/10/21.
//

import Foundation

typealias WebServiceResult<ResponseModel: Decodable> = ((Result<ResponseModel, WebServiceError>) -> Void)

protocol NetworkingProtocol {
	func performRequestForDecodable<ResponseModel: Decodable>(_ urlRequest: URLRequest, completion: @escaping WebServiceResult<ResponseModel>)
}

class NetworkManager: NetworkingProtocol {
	
	func performRequestForDecodable<ResponseModel: Decodable>(_ urlRequest: URLRequest, completion: @escaping WebServiceResult<ResponseModel>) {
		
		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			// Check for any errors
			guard error == nil else {
				completion(.failure(.unknown(error!)))
				return
			}
			
			// Make sure we have response data
			guard let responseData = data else {
				completion(.failure(.moreInfo("Response data is empty!")))
				return
			}
			
			// Attempt to decode responseData into passed in ResponseModel
			do {
				let responseModel = try JSONDecoder().decode(ResponseModel.self, from: responseData)
				completion(.success(responseModel))
			} catch {
				completion(.failure(.decodingError(error)))
			}
		}.resume()
	}
}
