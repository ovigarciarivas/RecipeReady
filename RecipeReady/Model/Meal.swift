//
//  Meal.swift
//  RecipeReady
//
//  Created by ovi on 8/14/24.
//

import Foundation

struct Meals: Codable {
    let meals: [Meal]
}

struct Meal: Identifiable, Codable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
    var id: String {
        return idMeal
    }
}
