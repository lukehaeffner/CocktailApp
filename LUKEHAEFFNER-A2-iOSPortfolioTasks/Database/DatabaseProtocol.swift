//
//  DatabaseProtocol.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 15/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import Foundation
enum DatabaseChange {
    case add
    case remove
    case update
}
enum ListenerType {
    case cocktail
    case ingredient
    case ingredientmeasurement
    case all
}
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onMyCocktailsChange(change: DatabaseChange, myCocktails: [Cocktail]) // changes to the saved cocktail list
    func onIngredientsChange(change: DatabaseChange, ingredients: [Ingredient])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addCocktail(name: String, instructions: String) -> Cocktail
    func addIngredient(name: String) -> Ingredient
    func addIngredientMeasurement(cocktail: Cocktail, ingredientName: String, measurement: String) -> IngredientMeasurement
    
    func createEmptyCocktail() -> Cocktail
    func editCocktail(cocktail: Cocktail) -> Cocktail
    func editCocktailName(cocktail: Cocktail, name: String)
    func editCocktailInstructions(cocktail: Cocktail, instructions: String)
    func editAddIngredientMeasurement(cocktail: Cocktail, ingredientName: String, measurement: String) -> IngredientMeasurement
    func editRemoveIngredientMeasurement(cocktail: Cocktail, ingredientMeasurement: IngredientMeasurement)
    func editSaveCocktail(cocktail: Cocktail)
    
    func removeIngredientFromCocktail(cocktail: Cocktail, ingredientMeasurement: IngredientMeasurement)
    func removeCocktail(cocktail: Cocktail)
    func fetchAllIngredients() -> [Ingredient]
    func fetchIngredientByName(ingredientName: String) -> [Ingredient] 
    func fetchCocktail(cocktailName: String, cocktailInstructions: String) -> [Cocktail]
    func fetchCocktailByName(cocktailName: String) -> [Cocktail]
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
