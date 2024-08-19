//
//  RecipeReadyApp.swift
//  RecipeReady
//
//  Created by ovi on 8/14/24.
//

import SwiftUI

@main
struct RecipeReadyApp: App {
    @StateObject var vm = RecipeViewModelImpl(service: RecipeServiceImpl())
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(vm)
        }
    }
}
