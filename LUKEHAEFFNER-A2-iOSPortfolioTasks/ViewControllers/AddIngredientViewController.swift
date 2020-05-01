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
    weak var databaseController: DatabaseProtocol?
    var ingredient: String!
    var ingredients:[Ingredient] = []
    var strIngredients:[String] = []
    @IBOutlet weak var qtyEditText: UITextField!
    var cocktail: Cocktail!
    
    @IBAction func addIngredient(_ sender: Any) {
        
        let measurement = qtyEditText.text!
        let _ = databaseController?.editAddIngredientMeasurement(cocktail: cocktail, ingredientName: ingredient, measurement: measurement)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        ingredientPicker.dataSource = self
        ingredientPicker.delegate = self
        ingredients = (databaseController?.fetchAllIngredients())!
        self.convertToString()
        // Do any additional setup after loading the view.
    }
    func convertToString() {
        for ingredient in ingredients {
            self.strIngredients.append(ingredient.name!)
        }
    }

}

extension AddIngredientViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return strIngredients.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(strIngredients[row])
        return ingredient = strIngredients[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return strIngredients[row]
    }
    
    
}
