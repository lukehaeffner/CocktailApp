//
//  EditDescriptionViewController.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 24/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class EditDescriptionViewController: UIViewController {

    @IBOutlet weak var editInstructions: UITextView!
    weak var databaseController: DatabaseProtocol?

    var cocktail:Cocktail!
    @IBAction func saveInstructions(_ sender: Any) {
        if editInstructions.text != "" {
            let instructions =  editInstructions.text!
            let _ = databaseController?.editCocktailInstructions(cocktail: cocktail, instructions: instructions)
            navigationController?.popViewController(animated: true)
            return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         databaseController = appDelegate.databaseController
        editInstructions.text = cocktail.instructions
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
