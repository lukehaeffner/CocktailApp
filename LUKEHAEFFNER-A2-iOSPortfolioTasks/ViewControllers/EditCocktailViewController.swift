//
//  EditCocktailViewController.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 13/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class EditCocktailViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    var databaseController: DatabaseProtocol!
    var cocktail: Cocktail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTextField.text = cocktail.name
    }
    
    @IBAction func saveName(_ sender: Any) {
        if editTextField.text != "" {
            let name =  editTextField.text!
            let _ = databaseController.editCocktailName(cocktail: cocktail!, name: name)
            navigationController?.popViewController(animated: true)
            return
        }
        displayMessage(title: "Missing fields", message: "A name must be provided for the drink")
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
