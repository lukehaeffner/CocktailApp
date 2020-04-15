//
//  IngredientMeasurement.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 8/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class IngredientMeasurement: NSObject {

    var name: String?
    var quantity: String?
    
    init(name: String, quantity: String) {
        self.name = name
        self.quantity = quantity
    }
}
