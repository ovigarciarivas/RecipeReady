//
//  CategoryDetailView.swift
//  RecipeReady
//
//  Created by ovi on 8/15/24.
//

import SwiftUI

struct CategoryDetailView: View {
    let category: Category
    
    @EnvironmentObject var vm: RecipeViewModelImpl
    
    var body: some View {
        VStack {
            switch vm.mealState {
            case .loading:
                ProgressView()
            case .failed(let error):
                ErrorView(error: error) {
                    Task {
                        await vm.fetchMeals(for: category.strCategory ?? "Dessert") // Fetching meals for the selected category
                    }
                }
            case .success(let meals):
                List(meals) { meal in
                    NavigationLink(destination: MealDetailView(mealID: meal.idMeal)) {
                        HStack {
                            AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40).cornerRadius(15)
                            } placeholder: {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40).cornerRadius(15)
                            }
                                                      
                            Text(meal.strMeal)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .leading)
                                .lineLimit(2)
                            
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            Task {
                await vm.fetchMeals(for: category.strCategory ?? "Dessert") // Fetching meals when the view appears
            }
        }
    }
}

