//
//  WebServiceError.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/10/21.
//

import Foundation

enum WebServiceError: Error {
	case invalidURL(String)
	case invalidPayload(URL)
	case decodingError(Error)
	case unknown(Error)
	case moreInfo(String)
}
