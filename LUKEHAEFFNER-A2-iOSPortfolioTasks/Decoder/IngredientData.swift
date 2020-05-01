//
//  IngredientData.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 24/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class IngredientData: NSObject, Decodable {
    var name:String
    
    private enum IngredientKeys: String, CodingKey {
        case strIngredient1
    }
    required init(from decoder: Decoder) throws {
        let ingredientContainer = try decoder.container(keyedBy: IngredientKeys.self)
        name = try ingredientContainer.decode(String.self, forKey: .strIngredient1)
    }
    
}
