//
//  DrinkData.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 24/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit
import Foundation

class DrinkData: NSObject, Decodable {
    var name: String
    var instructions: String
    var ingredients = [String]()
    var ingredientMeasurement = [String]()
    

    private enum RootKeys: String, CodingKey {
        case drinks
    }
    
    private enum DrinkKeys: String, CodingKey {
    
        case strDrink
        case strInstructions
        
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
    }

    
    required init(from decoder: Decoder) throws {
        let drinkContainer = try decoder.container(keyedBy: DrinkKeys.self)
        name = try drinkContainer.decode(String.self, forKey: .strDrink)
        instructions = try drinkContainer.decode(String.self, forKey: .strInstructions)
  
        
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient1) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure1) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient2) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure2) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient3) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure3) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient4) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure4) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient5) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure5) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient6) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure6) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient7) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure7) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient8) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure8) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient9) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure9) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient10) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure10) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient11) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure11) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient12) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure12) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient13) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure13) {
            ingredientMeasurement.append(measurement)
        }
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient14) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure14) {
            ingredientMeasurement.append(measurement)
        }
        
        if let ingredient  = try? drinkContainer.decode(String.self, forKey: .strIngredient15) {
            ingredients.append(ingredient)
        }
        if let measurement = try? drinkContainer.decode(String.self, forKey: .strMeasure15) {
            ingredientMeasurement.append(measurement)
        }
        
    }
}

