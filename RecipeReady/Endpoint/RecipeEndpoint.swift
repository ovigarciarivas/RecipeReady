//
//  RecipeEndpoint.swift
//  RecipeReady
//
//  Created by ovi on 8/14/24.
//

import Foundation

//The purpose of this protocol is to promote reusability in case we want to add another API endpoint
protocol APIBuilder {
    //Url request that we are going to send
    var urlRequest: URLRequest { get }
    
    //base url that the API is going to have
    var baseURL: URL { get }
    
    //path we are going to append to our baseURL
    var path: String { get }
}

//This enum is useful in defining our Recipe API. We can remove and add endpoints here.
enum RecipeAPI {
    case getCategories
    case getMeals(category: String)
    case getMealDetail(id: String)
}

//Network layer
//Our extension is now conforming to our recently created protocol,
//We must provide the values the protocol requires

extension RecipeAPI: APIBuilder {
    // The request is necessary to grab the baseURL and attach the path to it
    // while also taking into account query parameters
    var urlRequest: URLRequest {
        let urlString: String

        // Concatenating baseURL, path, and query parameter if necessary
        switch self {
        case .getCategories:
            urlString = "\(self.baseURL.absoluteString)\(self.path)"
        case .getMeals(let category):
            urlString = "\(self.baseURL.absoluteString)\(self.path)?c=\(category)"
        case .getMealDetail(let id):
            urlString = "\(self.baseURL.absoluteString)\(self.path)?i=\(id)"
        }

        // Create a URL from the constructed string
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL: \(urlString)")
        }

        // Return the URLRequest with the constructed URL
        return URLRequest(url: url)
    }

    // Main URL of our API
    var baseURL: URL {
        return URL(string: "https://www.themealdb.com/api")!
    }

    // Resources we want to access
    var path: String {
        switch self {
        case .getCategories:
            return "/json/v1/1/categories.php"
        case .getMeals:
            return "/json/v1/1/filter.php"
        case .getMealDetail:
            return "/json/v1/1/lookup.php"
        }
    }
}

