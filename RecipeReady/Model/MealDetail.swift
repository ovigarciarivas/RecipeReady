//
//  MealDetail.swift
//  RecipeReady
//
//  Created by ovi on 8/15/24.
//
import Foundation

// Top-level struct representing an array of meals.
struct MealDetail: Codable {
    
    // Nested struct representing the details of a single meal.
    struct Meal: Codable {
        let idMeal: String // Unique identifier for the meal.
        let strMeal: String // Name of the meal.
        let strDrinkAlternate: String? // Alternate drink name (Optional).
        let strCategory: String // Meal category (e.g., Beef, Seafood, Dessert).
        let strArea: String // Where the meal originated from (e.g., Italian, Mexican).
        let strInstructions: String // Cooking instructions for the meal.
        let strMealThumb: URL // URL of the meal's thumbnail image.
        let strTags: String? // Tags associated with the meal (e.g., "Hard, Easy").
        let strYoutube: String? // YouTube video link for the meal preparation (Optional).
        
        // We'll be using a dictionary to hold ingredients as keys and their specific measurements as values.
        let ingredients: [String: String]

        // Definition of the coding keys used to map the JSON keys to the struct's properties.
        enum CodingKeys: String, CodingKey {
            case idMeal, strMeal, strDrinkAlternate, strCategory, strArea, strInstructions, strMealThumb, strTags, strYoutube
            // Explicitly defining keys for ingredients and measurements.
            case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9
            case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9
        }
        
        // Custom init to decode JSON into a single Meal instance.
        init(from decoder: Decoder) throws {
            // Creating a container to hold the key-value pairs from the JSON.
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Decoding basic properties (We use ifPresent for nil properties).
            idMeal = try container.decode(String.self, forKey: .idMeal)
            strMeal = try container.decode(String.self, forKey: .strMeal)
            strDrinkAlternate = try container.decodeIfPresent(String.self, forKey: .strDrinkAlternate)
            strCategory = try container.decode(String.self, forKey: .strCategory)
            strArea = try container.decode(String.self, forKey: .strArea)
            strInstructions = try container.decode(String.self, forKey: .strInstructions)
            strMealThumb = try container.decode(URL.self, forKey: .strMealThumb)
            strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
            strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube)
            
            // Creating an empty ingredients dictionary.
            var ingredientsDict: [String: String] = [:]
            
            // Looping through the ingredient and measurement pairs.
            for index in 1...9 {
                let ingredientKey = CodingKeys(rawValue: "strIngredient\(index)")!
                let measureKey = CodingKeys(rawValue: "strMeasure\(index)")!
                
                // Decoding ingredients and their corresponding measures if they are not nil.
                if let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey),
                   let measure = try container.decodeIfPresent(String.self, forKey: measureKey) {
                    ingredientsDict[ingredient] = measure
                }
            }
            
            // Assigning the decoded ingredients and measurements to the ingredients property.
            ingredients = ingredientsDict
        }
        
        // Custom method to encode the Meal instance into JSON.
        func encode(to encoder: Encoder) throws {
            // Creating a container to store the key-value pairs.
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            // Encoding basic properties.
            try container.encode(idMeal, forKey: .idMeal)
            try container.encode(strMeal, forKey: .strMeal)
            try container.encodeIfPresent(strDrinkAlternate, forKey: .strDrinkAlternate)
            try container.encode(strCategory, forKey: .strCategory)
            try container.encode(strArea, forKey: .strArea)
            try container.encode(strInstructions, forKey: .strInstructions)
            try container.encode(strMealThumb, forKey: .strMealThumb)
            try container.encodeIfPresent(strTags, forKey: .strTags)
            try container.encodeIfPresent(strYoutube, forKey: .strYoutube)
            
            // Looping through the ingredients dictionary to encode each ingredient and its specific measurement.
            for (index, (ingredient, measure)) in Array(ingredients).enumerated() {
                let ingredientKey = CodingKeys(rawValue: "strIngredient\(index + 1)")!
                let measureKey = CodingKeys(rawValue: "strMeasure\(index + 1)")!
                try container.encode(ingredient, forKey: ingredientKey)
                try container.encode(measure, forKey: measureKey)
            }
        }
    }

    let meals: [Meal] // Array of meals representing the data of multiple meals.
}



