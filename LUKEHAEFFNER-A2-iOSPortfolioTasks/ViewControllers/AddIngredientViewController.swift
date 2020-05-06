//
//  AddIngredientViewController.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 24/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class AddIngredientViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    var databaseController: DatabaseProtocol!
    var ingredient: String!
    var ingredients:[Ingredient] = []
    var strIngredients:[String] = []
    @IBOutlet weak var qtyEditText: UITextField!
    var cocktail: Cocktail!
    @IBOutlet weak var editSelectedIngredient: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredients = databaseController.fetchAllIngredients()
        self.convertToString()
        self.editSelectedIngredient.delegate = self
        setupPickerView()
        
        // Do any additional setup after loading the view.
    }
    
    /**
     Initialize the pickerview. This sets the editSelectedIngredient inputview to display the pickerview when clicked
     */
    func setupPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        editSelectedIngredient.inputView = pickerView
    }
    
    /**
     This is the delegrate responsible for disallowing manual keyboard entry into the ingredient textfield
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
 
    /**
     Convert all Ingredient class items to a list of strings to display in the UIPicker
     */
    func convertToString() {
        for ingredient in ingredients {
            self.strIngredients.append(ingredient.name!)
        }
    }
    
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
    //MARK: - PickerView Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return strIngredients.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        editSelectedIngredient.text = strIngredients[row]
        return ingredient = strIngredients[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return strIngredients[row]
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

