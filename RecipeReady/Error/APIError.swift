//
//  APIError.swift
//  RecipeReady
//
//  Created by ovi on 8/14/24.
//

import Foundation

enum APIError: Error {
    //Will handle if the object fails to decode
        //ex. the structure of the data from the JSON changes
    case decodingError
    
    //This error will throw a status code and contains an
    //associated value of type Int for the specific status code
    case errorCode(Int)
    
    //Any error that is not recognized
    case unknown
}

//Each error above needs its own description and we can do this
//with an extension on our enum

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError : return "Error decoding object from service"
        case let .errorCode(code) : return "\(code) - Something went wrong"
        case .unknown : return "The error is unknown"
        }
    }
}
