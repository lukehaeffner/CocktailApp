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
    weak var databaseController: DatabaseProtocol?
    var cocktail: Cocktail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        editTextField.text = cocktail.name
    }
    

    @IBAction func saveName(_ sender: Any) {
        if editTextField.text != "" {
            let name =  editTextField.text!
            cocktail.name = name
//            let _ = databaseController?.editCocktailName(cocktail: cocktail!, name: name)
            navigationController?.popViewController(animated: true)
            return
        }
        
        
    }
    /*
    // MARK: - Navigation
*/
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
    

}
