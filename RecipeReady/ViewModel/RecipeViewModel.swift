//
//  RecipeViewModel.swift
//  RecipeReady
//
//  Created by ovi on 8/14/24.
//

import Foundation

// Protocol defining requirements for the RecipeViewModel
protocol RecipeViewModel {
    func fetchCategories() async // Fetch the list of categories
    func fetchMeals(for category: String) async // Fetch meals for a specific category
    func fetchMealDetail(for mealID: String) async // Fetch meal details based on meal ID
}

// Implementation of the RecipeViewModel protocol
class RecipeViewModelImpl: ObservableObject, RecipeViewModel {
    private let service: RecipeService
    
    // Stores the fetched categories
    private(set) var categories: [Category] = []
    
    // Stores the fetched meals for a given category
    private(set) var meals: [Meal] = []
    
    // Stores the details of a specific meal
    private(set) var mealDetail: MealDetail.Meal?
    
    // Published properties to track the state of category/meal fetching (loading, success, failure)
    @Published private(set) var categoryState: ResultState<[Category]> = .loading
    @Published private(set) var mealState: ResultState<[Meal]> = .loading
    @Published private(set) var mealDetailState: ResultState<MealDetail.Meal?> = .loading
    
    // Initializer that injects the service
    init(service: RecipeService) {
        self.service = service
    }
    
    // Fetches the list of categories from the service
    @MainActor
    func fetchCategories() async {
        print("Fetching categories...")
        self.categoryState = .loading // Sets the state to loading before starting the fetch
        
        do {
            // Attempt to fetch categories from the service
            self.categories = try await service.fetchCategories(from: .getCategories).categories
            print(categories.count)
            self.categoryState = .success(content: self.categories) // Updates state to success with fetched categories
        } catch let error {
            print("Error fetching categories")
            self.categoryState = .failed(error: error) // Updates state to failed and passing in the error
        }
    }
    
    // Fetches meals for a specific category from the service
    @MainActor
    func fetchMeals(for category: String) async {
        print("Fetching meals for category \(category)...")
        self.mealState = .loading // Sets the state to loading before the fetch
        
        do {
            // Attempt to fetch meals for the given category
            self.meals = try await service.fetchMeals(for: category, from: .getMeals(category: category)).meals
            print(meals.count)
            self.mealState = .success(content: self.meals) // Updates state to success with fetched meals
        } catch let error {
            print("Error fetching meals")
            self.mealState = .failed(error: error) // Updates state to failed and passing in the error
        }
    }

    // Fetches detailed information for a specific meal using its ID
    @MainActor
    func fetchMealDetail(for mealID: String) async {
        print("Fetching meal details for meal ID \(mealID)...")
        self.mealDetailState = .loading // Sets the state to loading before fetching
        
        do {
            // Attempt to fetch meal details for the given meal ID
            let mealDetail = try await service.fetchMealDetail(by: mealID, from: .getMealDetail(id: mealID)).meals.first
            print("Fetched details for meal: \(mealID)")
            self.mealDetail = mealDetail // If successful, store the fetched meal detail
            self.mealDetailState = .success(content: mealDetail) // Updates state to success with the meal detail
        } catch let error {
            print("Error fetching meal details")
            self.mealDetailState = .failed(error: error) // Updates state to failed and passing in the error
        }
    }
}



