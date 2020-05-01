//
//  MyDrinksTableViewController.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 8/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class MyDrinksTableViewController: UITableViewController, DatabaseListener {
    let CELL_DRINK = "drinkCell"
    let CELL_INFO = "drinkCountCell"
    let SECTION_DRINK = 0
    let SECTION_INFO = 1
    var currentDrinks: [Cocktail] = []
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_DRINK:
                return currentDrinks.count
            case SECTION_INFO:
                return 1
            default:
                return 0
        }
    }

    // This is for the rows in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This is for each drink thats in the CoreData, display its information
        if indexPath.section == SECTION_DRINK {
            let drinkCell = tableView.dequeueReusableCell(withIdentifier: CELL_DRINK, for: indexPath)
                as! MyDrinksTableViewCell
            let drink = currentDrinks[indexPath.row]
            drinkCell.drinkLabel.text = drink.name
            drinkCell.ingredientsLabel.text = drink.instructions
            return drinkCell
        }
        // For the Drink Count section
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        cell.textLabel?.textColor = .secondaryLabel
        cell.selectionStyle = .none
        if currentDrinks.count > 0 {
            cell.textLabel?.text = "\(currentDrinks.count) drinks in list"
        } else {
            cell.textLabel?.text = "No drinks added. Click + to add drink"
        }
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_DRINK {
            return true
        }
        return false
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_DRINK {
            self.databaseController!.removeCocktail(cocktail: currentDrinks[indexPath.row])
        }
    }

    
    // MARK: - Database Listener
    func onMyCocktailsChange(change: DatabaseChange, myCocktails: [Cocktail]) {
        currentDrinks = myCocktails
        tableView.reloadData()
    }
    
    // Unused for this view controller
    func onIngredientsChange(change: DatabaseChange, ingredients: [Ingredient]) {}
    func onIngredientMeasurementChange(change: DatabaseChange, ingredients: [IngredientMeasurement]) {}
    func onNameChange(change: DatabaseChange, cocktail: Cocktail) {}
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "showCocktailSegue" , let cell = sender as? MyDrinksTableViewCell{
            if let indexPath = tableView.indexPath(for: cell) {
                let destination = segue.destination as! CreateDrinkTableViewController
                destination.chosenCocktail = currentDrinks[indexPath.row]
            }
            
        }
    }
    

}
