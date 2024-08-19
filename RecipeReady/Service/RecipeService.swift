//
//  RecipeService.swift
//  RecipeReady
//
//  Created by ovi on 8/14/24.
//

import SwiftUI

protocol RecipeService {
    func fetchCategories(from endpoint: RecipeAPI) async throws -> Categories
    func fetchMeals(for category: String, from endpoint: RecipeAPI) async throws -> Meals 
    func fetchMealDetail(by id: String, from endpoint: RecipeAPI) async throws -> MealDetail
}

// Marked as final because we don't want any other class to be able to subclass
final class RecipeServiceImpl: RecipeService {
    func fetchCategories(from endpoint: RecipeAPI) async throws -> Categories {
        let urlSession = URLSession.shared
        let (data, response) = try await urlSession.data(for: endpoint.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(Categories.self, from: data)
    }
    
    func fetchMeals(for category: String, from endpoint: RecipeAPI) async throws -> Meals {
        let urlSession = URLSession.shared
        let (data, response) = try await urlSession.data(for: endpoint.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("Response error \(response)")
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(Meals.self, from: data)
    }
    func fetchMealDetail(by id: String, from endpoint: RecipeAPI) async throws -> MealDetail {
        let urlSession = URLSession.shared
        let (data, response) = try await urlSession.data(for: endpoint.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("Response error: \(response)")
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(MealDetail.self, from: data)
    }
}

