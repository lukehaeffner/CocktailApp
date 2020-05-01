//
//  DefaultIngredients.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 24/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit
import Foundation

class DefaultIngredients: NSObject, Decodable {
    var ingredients: [IngredientData]?
       
    private enum CodingKeys: String, CodingKey {
       case ingredients = "drinks"
    }
}
