//
//  SearchDrinksTableViewController.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 13/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class SearchDrinksTableViewController: UITableViewController,UISearchResultsUpdating , addCocktailDelegate {

    let CELL_DRINK = "drinkCell"
    let CELL_RESULTS = "drinkCountCell"

    let SECTION_DRINK = 0
    let SECTION_INFO = 1
    var allDrinks: [Cocktail] = []
    var filteredDrinks: [Cocktail] = []
    weak var cocktailDelegate: addCocktailDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTemplateDrinks()
        filteredDrinks = allDrinks
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cocktails"
        navigationItem.searchController = searchController
         definesPresentationContext = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Search Bar Stuff
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        if searchText.count > 0 {
            filteredDrinks = allDrinks.filter({ (drink: Cocktail) -> Bool in
                return drink.name!.lowercased().contains(searchText)
            })
        }
        else {
            filteredDrinks = allDrinks
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_DRINK:
                return filteredDrinks.count
            case SECTION_INFO:
                if filteredDrinks.count > 0 {
                    return 0
                }
                return 1
            default:
                return 0
        }
    }

    
    
    // this is the drink cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == SECTION_DRINK {
            let drinkCell = tableView.dequeueReusableCell(withIdentifier: CELL_DRINK, for: indexPath) as! MyDrinksTableViewCell
            
            let drink = filteredDrinks[indexPath.row]
            drinkCell.drinkLabel.text = drink.name
            drinkCell.ingredientsLabel.text = drink.instructions
            return drinkCell
        }

           let cell = tableView.dequeueReusableCell(withIdentifier: CELL_RESULTS, for: indexPath)
           cell.textLabel?.textColor = .secondaryLabel
           cell.textLabel?.text = "No drinks added. Click to add drink" // this is for if the search returns 0
           
           return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_INFO {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }

            
        if cocktailDelegate?.addCocktail(newCocktail: allDrinks[indexPath.row]) ?? false {
            navigationController?.popViewController(animated: false)
            return
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addCocktail(newCocktail: Cocktail) -> Bool {
        allDrinks.append(newCocktail)
        filteredDrinks.append(newCocktail)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: filteredDrinks.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
        tableView.reloadSections([SECTION_INFO], with: .automatic)
        return true
    }

    func createTemplateDrinks() {
        allDrinks.append(Cocktail(name: "Bloody Mary", instructions: "This is a test set of instructions", ingredients: [IngredientMeasurement(name: "Cherry", quantity: "Two"), IngredientMeasurement(name: "Berry", quantity: "Four")]))
        allDrinks.append(Cocktail(name: "Old Fashioned", instructions: "This is a another set of example instructions", ingredients: [IngredientMeasurement(name: "Cherry", quantity: "Two")]))

    }
}
