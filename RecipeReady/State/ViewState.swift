//
//  ViewState.swift
//  RecipeReady
//
//  Created by ovi on 8/14/24.
//

import Foundation
//The View State is going to control the content the user sees on the screen
//This sets up what we do in our ViewModel next
//Depending on the particular state that gets sent to the View we'll change the UI
enum ResultState<T: Codable> {
    //A loading spinner
    case loading
    
    //This is what we use to populate our list of categories
    case success(content: T)
    
    //We use Error instead of APIError in order to keep it generic and
    //not tie it directly to APIError
    case failed(error: Error)
}
