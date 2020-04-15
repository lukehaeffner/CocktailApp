//
//  Cocktail.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 8/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class Cocktail: NSObject {

    var name: String?
    var instructions: String?
    var ingredients:  [IngredientMeasurement]
    
    init(name: String, instructions: String, ingredients: [IngredientMeasurement]) {
        self.name = name
        self.instructions = instructions
        self.ingredients = ingredients
    }
}
