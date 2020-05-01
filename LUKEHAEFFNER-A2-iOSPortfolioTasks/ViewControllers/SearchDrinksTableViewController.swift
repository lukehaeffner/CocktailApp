//
//  SearchDrinksTableViewController.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 13/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit

class SearchDrinksTableViewController: UITableViewController,UISearchBarDelegate , DatabaseListener {
    func onNameChange(change: DatabaseChange, cocktail: Cocktail) {
        // do nothing
    }
    
    func onMyCocktailsChange(change: DatabaseChange, myCocktails: [Cocktail]) {
//
    }
    
    func onIngredientsChange(change: DatabaseChange, ingredients: [Ingredient]) {
        // do nothing
    }
    
    func onIngredientMeasurementChange(change: DatabaseChange, ingredients: [IngredientMeasurement]) {
        // do nothing
    }

    let CELL_DRINK = "drinkCell"
    let CELL_RESULTS = "drinkCountCell"

    let SECTION_DRINK = 0
    let SECTION_INFO = 1
    var indicator = UIActivityIndicatorView()

    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    var newDrinks = [DrinkData]()
    let REQUEST_STRING = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        let searchController = UISearchController(searchResultsController: nil)
           searchController.searchBar.delegate = self
           searchController.obscuresBackgroundDuringPresentation = false
           searchController.searchBar.placeholder = "Find drink"
           navigationItem.searchController = searchController
           // Make sure search bar is always visible.
           navigationItem.hidesSearchBarWhenScrolling = false

           // This view controller decides how the search controller is presented.
           definesPresentationContext = true

           // Create a loading animation
           indicator.style = UIActivityIndicatorView.Style.medium
           indicator.center = self.tableView.center
           self.view.addSubview(indicator)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    
    //MARK: Search Bar Delegate
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         // If there is no text end immediately
         guard let searchText = searchBar.text, searchText.count > 0 else {
             return;
         }

         indicator.startAnimating()
         indicator.backgroundColor = UIColor.clear

         newDrinks.removeAll()
         tableView.reloadData()
         URLSession.shared.invalidateAndCancel()
         requestDrinks(drinkName: searchText)
     }
    
    // MARK: - API Request
    
    func requestDrinks(drinkName: String) {
        let searchString = REQUEST_STRING + drinkName
        
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        let task = URLSession.shared.dataTask(with: jsonURL!){(data, response, error) in
            DispatchQueue.main.async{
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
            
            if let error = error {
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let volumeData = try decoder.decode(VolumeData.self, from: data!)

                if let books = volumeData.books {
                    self.newDrinks.append(contentsOf: books)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_DRINK:
                return newDrinks.count
            case SECTION_INFO:
                if newDrinks.count > 0 {
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
            let drink = newDrinks[indexPath.row]
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
        
        let cocktail = databaseController?.addCocktail(name: newDrinks[indexPath.row].name, instructions: newDrinks[indexPath.row].instructions)
        let ingredients = newDrinks[indexPath.row].ingredients
        let measurements = newDrinks[indexPath.row].ingredientMeasurement
        for n in 0...newDrinks[indexPath.row].ingredientMeasurement.count - 1 {
            let _ = databaseController?.addIngredientMeasurement(cocktail: cocktail!, ingredientName: ingredients[n], measurement: measurements[n])
        }
        
        navigationController?.popViewController(animated: false)
        return
   
//        if databaseController?.addCocktail(name: newDrinks[indexPath.row].name, instructions: newDrinks[indexPath.row].instructions) != nil {
//            navigationController?.popViewController(animated: false)
//            return
//        }

//        tableView.deselectRow(at: indexPath, animated: true)
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
