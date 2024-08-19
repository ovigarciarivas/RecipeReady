//
//  HomeView.swift
//  RecipeReady
//
//  Created by ovi on 8/14/24.
//

import SwiftUI

struct HomeView: View {
    // Injects the RecipeViewModelImpl from the environment, which manages fetching and storing categories/meals.
    @EnvironmentObject var vm: RecipeViewModelImpl
    
    var body: some View {
        Group {
            switch vm.categoryState {
            // Show a Progress View while the categories are being fetched.
            case .loading:
                ProgressView()
                
            // Show an error view if fetching categories fails, with a button that attempts to fetch categories again.
            case .failed(let error):
                ErrorView(error: error) {
                    Task {
                        await vm.fetchCategories() // Retry fetching categories on button tap.
                    }
                }
                
            // When categories are successfully fetched, show the list of categories using a navigation view (Navigation Path can also be used).
            case .success:
                NavigationView {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(alignment: .leading) {
                            // Iterate over each category and create a NavigationLink to CategoryDetailView.
                            ForEach(vm.categories, id: \.id) { category in
                                NavigationLink(destination: CategoryDetailView(category: category)) {
                                    createCategoryComponent(category: category) // Custom UI component for each category.
                                }
                            }
                        }
                    }
                    .navigationTitle("Categories")
                }
            }
        }
        .onAppear {
            // When the view appears fetch our categories
            Task {
                await vm.fetchCategories()
            }
        }
    }
    
    // Helper function to create a UI component for each category.
    func createCategoryComponent(category: Category) -> some View {
        HStack {
            // Display the category's thumbnail image if not nil.
            if let imageURL = category.strCategoryThumb,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(maxWidth: 100)
                        .frame(maxHeight: .infinity)
                } placeholder: {
                    // Placeholder image while the thumbnail loads.
                    Image(systemName: "photo.fill")
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .frame(width: 100, height: 100)
                }
            }
            
            // Category's name and description.
            VStack(alignment: .leading, spacing: 5) {
                Text(category.strCategory ?? "")
                    .foregroundColor(.primary)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                
                Text(category.strCategoryDescription ?? "N/A")
                    .foregroundColor(.primary)
                    .font(.subheadline)
                    .fontWeight(.light)
            }
            .padding()
        }
        .frame(maxWidth: 500, maxHeight: 105)
        .background(.thickMaterial) // Thick material background for a contrasting effect.
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    HomeView()
        .environmentObject(RecipeViewModelImpl(service: RecipeServiceImpl()))
}

