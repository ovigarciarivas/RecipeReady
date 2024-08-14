//
//  ContentView.swift
//  RecipeReady
//
//  Created by ovi on 8/14/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: RecipeViewModelImpl
    var body: some View {
        Group {
            switch vm.categoryState {
            case .loading : ProgressView()
            case .failed(let error): ErrorView(error: error) {
                Task {
                    await vm.fetchCategories()
                }
            }
            case .success(let categories):
                NavigationView {
                    List(categories) { category in
                        NavigationLink(destination: CategoryDetailView(category: category)) {
                            createCategoryComponent(category: category)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Categories")
                }
            }
        }
        .onAppear {
            Task {
                await vm.fetchCategories()
            }
        }
    }
    
    func createCategoryComponent(category: Category) -> some View {
        HStack {
            if let imageURL = category.strCategoryThumb,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(maxWidth: 100)
                        .frame(maxHeight: .infinity)
                } placeholder: {
                    Image(systemName: "photo.fill")
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .frame(width: 100, height: 100)
                }
            }
            
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
        .background(.thickMaterial)
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    ContentView()
}
