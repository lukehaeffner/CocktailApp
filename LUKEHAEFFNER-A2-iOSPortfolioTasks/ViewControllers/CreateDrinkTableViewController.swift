//
//  CreateDrinkTableViewController.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 8/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class CreateDrinkTableViewController: UITableViewController, DatabaseListener {
    let SECTION_NAME = 0
    let SECTION_INSTRUCTIONS = 1
    let SECTION_INGREDIENTS = 2
    let SECTION_ADD_INGREDIENTS = 3
    
    let CELL_NAME = "nameCell"
    let CELL_INSTRUCTIONS = "instructionCell"
    let CELL_INGREDIENTS = "ingredientCell"
    let CELL_ADD_INGREDIENTS = "addIngredientCell"
    
    var chosenCocktail: Cocktail!
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        if chosenCocktail == nil {
            self.navigationItem.title = "Create Cocktail"
            chosenCocktail = databaseController?.createEmptyCocktail()
        } else {
            self.navigationItem.title = "Edit Cocktail"
            chosenCocktail = databaseController?.editCocktail(cocktail: chosenCocktail!)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         databaseController?.addListener(listener: self)
     }

     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         databaseController?.removeListener(listener: self)
     }

    // MARK: - Table View Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_INGREDIENTS:
            return chosenCocktail?.ingredients?.count ?? 1
        default:
            return 1
        }
    }
    
    // Give the sections a header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        switch section {
            case SECTION_INGREDIENTS:
                return "Ingredients"
            case SECTION_INSTRUCTIONS:
                return "Instructions"
            case SECTION_NAME:
                return "Cocktail Name"
            default:
                return nil
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_NAME {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NAME, for: indexPath)
            
            cell.textLabel?.text = chosenCocktail?.name ?? "Enter Cocktail Name"
            if chosenCocktail == nil {
                cell.textLabel?.textColor = .secondaryLabel
            }
            return cell
        }
        else if indexPath.section == SECTION_INSTRUCTIONS {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INSTRUCTIONS, for: indexPath)
            cell.textLabel?.text = chosenCocktail?.instructions ?? "Enter Cocktail Instruction"
            if chosenCocktail == nil {
                cell.textLabel?.textColor = .secondaryLabel
            }
            return cell
        }
        else if indexPath.section == SECTION_INGREDIENTS {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENTS, for: indexPath)
            let ingre = chosenCocktail?.ingredients?.allObjects as! [IngredientMeasurement]
            cell.textLabel?.text = ingre[indexPath.row].name
            cell.detailTextLabel?.text = ingre[indexPath.row].quantity
            cell.detailTextLabel?.textColor = .secondaryLabel
            return cell
        }
        //this is for every ingredient added
        let drinkCell = tableView.dequeueReusableCell(withIdentifier: CELL_ADD_INGREDIENTS, for: indexPath)
        drinkCell.textLabel?.text =  "Enter Cocktail Ingredient"
        drinkCell.textLabel?.textColor = .secondaryLabel
        return drinkCell
    }
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // make it so you can remove a cocktail
        if indexPath.section == SECTION_INGREDIENTS {
            return true
        }
        return false
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_INGREDIENTS {
            let cocktailIngredients = chosenCocktail.ingredients?.allObjects as! [IngredientMeasurement]
            let ingredient = cocktailIngredients[indexPath.row] as IngredientMeasurement
            let _ = databaseController?.editRemoveIngredientMeasurement(cocktail: chosenCocktail, ingredientMeasurement: ingredient)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    // MARK: - Save Cocktail
    @IBAction func saveDrink(_ sender: Any) {
        if chosenCocktail.name == nil || chosenCocktail.instructions == nil || chosenCocktail.ingredients?.count == 0 {
            displayMessage(title: "Missing Fields", message: "A cocktail must contain a name, some instructions and an ingredient")
            return
        }


        // create a real cocktail in the parent context
        let _ = databaseController?.editSaveCocktail(cocktail: chosenCocktail)
        navigationController?.popViewController(animated: true)
        return
    }
    
    
    // MARK: - Database Funtions
    func onMyCocktailsChange(change: DatabaseChange, myCocktails: [Cocktail]) {
        tableView.reloadData()
    }
    func onIngredientsChange(change: DatabaseChange, ingredients: [Ingredient]) {}
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // adding ingredients
        if segue.identifier == "showIngredientsSegue" {
            let destination = segue.destination as! AddIngredientViewController
            destination.cocktail = self.chosenCocktail
            destination.databaseController = self.databaseController

        }
        // editing name
        if segue.identifier == "editNameSegue" {
            let destination = segue.destination as! EditCocktailViewController
            destination.cocktail = self.chosenCocktail
            destination.databaseController = self.databaseController

        }
        // editing instructions
        if segue.identifier == "editInstructionSegue" {
            let destination = segue.destination as! EditDescriptionViewController
            destination.cocktail = self.chosenCocktail
            destination.databaseController = self.databaseController
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
