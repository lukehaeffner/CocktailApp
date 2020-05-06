//
//  AddIngredientViewController.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 24/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class AddIngredientViewController: UIViewController {

    @IBOutlet weak var ingredientPicker: UIPickerView!
    var databaseController: DatabaseProtocol!
    var ingredient: String!
    var ingredients:[Ingredient] = []
    var strIngredients:[String] = []
    @IBOutlet weak var qtyEditText: UITextField!
    var cocktail: Cocktail!
    
    @IBAction func addIngredient(_ sender: Any) {
        let measurement = qtyEditText.text
        
        // check for empty fields
        if measurement == "" {
            displayMessage(title: "Missing Fields", message: "Quantity is a required field")
            return
        }
        if ingredient == nil {
            displayMessage(title: "Missing Fields", message: "Ingredient is a required field")
            return
        }
        
        // check if the ingredient is already present in the cocktail.
        // Was meant to use the fully implemented fetchIngredientByName?
        let cocktailIngredients = cocktail.ingredients?.allObjects
        for ingredients in cocktailIngredients as! [IngredientMeasurement]  {
            if ingredients.name! == ingredient {
                displayMessage(title: "Duplicate Ingredient", message: "Ingredient already added to cocktail")
                return
            }
        }
        let _ = databaseController.editAddIngredientMeasurement(cocktail: cocktail, ingredientName: ingredient, measurement: measurement!)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientPicker.dataSource = self
        ingredientPicker.delegate = self
        ingredients = databaseController.fetchAllIngredients()
        self.convertToString()
        // Do any additional setup after loading the view.
    }
    
    /**
     Convert all Ingredient class items to a list of strings to display in the UIPicker
     */
    func convertToString() {
        for ingredient in ingredients {
            self.strIngredients.append(ingredient.name!)
        }
    }
    
    /**
     Display an error message to the user when a field isn't correctly filled in
     - Parameters:
        - title: The title of the error message
        - message: The message in the body of the error message
     */
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
        preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
        UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

/**
 This is the class responsible for rendering the UIPickerView
 */
extension AddIngredientViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return strIngredients.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return ingredient = strIngredients[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return strIngredients[row]
    }
    
    
}
