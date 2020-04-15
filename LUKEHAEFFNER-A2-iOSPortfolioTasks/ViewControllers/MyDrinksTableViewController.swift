//
//  MyDrinksTableViewController.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 8/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class MyDrinksTableViewController: UITableViewController, addCocktailDelegate {

    let CELL_DRINK = "drinkCell"
    let CELL_INFO = "drinkCountCell"
    let SECTION_DRINK = 0
    let SECTION_INFO = 1
    var currentDrinks: [Cocktail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

    // different cell information
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        if indexPath.section == SECTION_DRINK {
            let drinkCell = tableView.dequeueReusableCell(withIdentifier: CELL_DRINK, for: indexPath)
            as! MyDrinksTableViewCell
            let drink = currentDrinks[indexPath.row]

            drinkCell.drinkLabel.text = drink.name
            drinkCell.ingredientsLabel.text = drink.instructions

            return drinkCell
        }

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
            tableView.performBatchUpdates({
                self.currentDrinks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }, completion: nil)
        }
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "searchCocktailSegue" {
            let destination = segue.destination as! SearchDrinksTableViewController
            destination.cocktailDelegate = self
        }
        
        if segue.identifier == "showCocktailSegue" , let cell = sender as? MyDrinksTableViewCell{
            if let indexPath = tableView.indexPath(for: cell) {
                let destination = segue.destination as! CreateDrinkTableViewController
                destination.chosenCocktail = currentDrinks[indexPath.row]
            }
            
        }
    }
    

    func addCocktail(newCocktail: Cocktail) -> Bool {
        tableView.performBatchUpdates({
            currentDrinks.append(newCocktail)
            tableView.insertRows(at: [IndexPath(row: currentDrinks.count - 1, section: SECTION_DRINK)], with: .automatic)
        }, completion: nil)
        return true
    }
}
