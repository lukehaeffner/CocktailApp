//
//  CreateDrinkTableViewController.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 8/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class CreateDrinkTableViewController: UITableViewController {

    let SECTION_NAME = 0
    let SECTION_INSTRUCTIONS = 1
    let SECTION_INGREDIENTS = 2
    
    let CELL_NAME = "nameCell"
    let CELL_INSTRUCTIONS = "instructionCell"
    let CELL_INGREDIENTS = "ingredientCell"
    weak var chosenCocktail: Cocktail?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_INGREDIENTS:
            return chosenCocktail?.ingredients.count ?? 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        switch section {
            case SECTION_INGREDIENTS:
                return "Ingredients"
            case SECTION_INSTRUCTIONS:
                return "Instructions"
            default:
                return "Cocktail Name"
        }
    }
    
//
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
        
        // this is for every ingredient added
        let drinkCell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENTS, for: indexPath)
        let drink = chosenCocktail?.ingredients[indexPath.row]
        drinkCell.textLabel?.text = drink?.name ?? "Enter Cocktail Ingredient"
        if chosenCocktail == nil {
            drinkCell.textLabel?.textColor = .secondaryLabel
        }
        return drinkCell
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


}
