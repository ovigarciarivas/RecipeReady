//
//  Category.swift
//  RecipeReady
//
//  Created by ovi on 8/14/24.
//

import Foundation

struct Categories: Codable {
    let categories: [Category]
}

struct Category: Identifiable, Codable {
    var id: String {
        return idCategory ?? ""
    }
    var idCategory: String?
    var strCategory: String?
    var strCategoryThumb: String?
    var strCategoryDescription: String?
}

