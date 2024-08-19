//
//  MealDetailView.swift
//  RecipeReady
//
//  Created by ovi on 8/15/24.
//

import SwiftUI

import SwiftUI

struct MealDetailView: View {
    @EnvironmentObject var vm: RecipeViewModelImpl
    let mealID: String
    
    var body: some View {
        VStack {
            // Check if mealDetail is available, if not show a ProgressView
            if let mealDetail = vm.mealDetail {
                ScrollView(.vertical, showsIndicators: false) {
                    // Display meal image
                    mealImage
                    
                    // Display meal title and ingredients header
                    mealTitleAndIngredientsHeader(mealDetail)
                    
                    // Display list of ingredients
                    ingredientsList(mealDetail)
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            // Fetch meal details when the view appears
            Task {
                await vm.fetchMealDetail(for: mealID)
                print("Fetching Meal Details for: \(String(describing: vm.mealDetail?.ingredients.values))")
            }
        }
    }
    
    // Computed property to display the meal image
    private var mealImage: some View {
        Group {
            if let url = vm.mealDetail?.strMealThumb {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .padding(.horizontal)
                } placeholder: {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .padding(.horizontal)
                }
            } else {
                // Return an empty view if no image URL is available
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                    .padding(.horizontal)
                    .hidden() // Hide the view if image == nil
            }
        }
    }

    
    // Computed property to display the meal title and ingredients header
    private func mealTitleAndIngredientsHeader(_ mealDetail: MealDetail.Meal) -> some View {
        VStack(alignment: .leading) {
            Text(mealDetail.strMeal.uppercased()) // Display the meal title
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom)
            
            HStack {
                Text("Ingredients") // Ingredients section header
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("\(mealDetail.ingredients.count) items") // Show the count of ingredients
            }
        }
        .padding(.horizontal)
    }
    
    // Computed property to display the list of ingredients
    private func ingredientsList(_ mealDetail: MealDetail.Meal) -> some View {
        LazyVStack {
            // Looping through the dictionary of ingredients and measures
            ForEach(Array(mealDetail.ingredients), id: \.key) { key, value in
                if !key.isEmpty { // Only display non-empty ingredient names
                    HStack {
                        Text(key) // Ingredient name
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(value) // Measurement
                            .font(.subheadline)
                    }
                    .padding(.vertical)
                }
            }
        }
        .padding(.horizontal)
    }
}


#Preview {
    MealDetailView(mealID: "53041")
        .environmentObject(RecipeViewModelImpl(service: RecipeServiceImpl()))
}
