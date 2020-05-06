//
//  EditDescriptionViewController.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 24/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class EditDescriptionViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var editInstructions: UITextView!
    var databaseController: DatabaseProtocol!
    var cocktail:Cocktail!
    
    @IBAction func saveInstructions(_ sender: Any) {
        if editInstructions.text != "" {
            let instructions =  editInstructions.text!
            let _ = databaseController.editCocktailInstructions(cocktail: cocktail, instructions: instructions)
            navigationController?.popViewController(animated: true)
            return
        }
        
        displayMessage(title: "Missing Fields", message: "Instructions for the cocktail must be provided")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
        Placeholder text for the edit text. If the cocktail doesnt have instructions, set the text to grey like placeholder, and set the placeholder text
         */
        if cocktail.instructions == nil {
            editInstructions.delegate = self
            editInstructions.textColor = .lightGray
            editInstructions.text = "Insert Instructions..."
        }
        else {
            editInstructions.text = cocktail.instructions
        }
    }
    
    /**
     This is to setup a bit of a placeholder text for the TextField to make it a bit clearer to the user that they can input
     Text in that field. This plays a trick on the fact that the only text that should be lightGrey is when its set initially to make a fake placeholder text
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
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
