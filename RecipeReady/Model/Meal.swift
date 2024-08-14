//
//  Dessert.swift
//  RecipeReady
//
//  Created by ovi on 8/14/24.
//

import Foundation

struct Desserts: Codable {
    let meals: [Dessert]
}

struct Dessert: Identifiable, Codable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
    var id: String {
        return idMeal
    }
}
