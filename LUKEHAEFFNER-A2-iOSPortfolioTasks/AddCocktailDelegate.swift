//
//  AddCocktailDelegate.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 13/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import Foundation

protocol addCocktailDelegate: AnyObject {
    func addCocktail(newCocktail: Cocktail) -> Bool
}
