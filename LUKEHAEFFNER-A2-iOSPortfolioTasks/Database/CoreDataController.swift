//
//  CoreDataController.swift
//  LUKEHAEFFNER-A2-iOSPortfolioTasks
//
//  Created by Luke Haeffner on 15/4/20.
//  Copyright © 2020 Luke Haeffner. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    let INGREDIENTS_URL = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
    var allCocktailsFetchedResultsController: NSFetchedResultsController<Cocktail>?
    var allIngredientsFetchedResultsController: NSFetchedResultsController<Ingredient>?

    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "LUKEHAEFFNER_A2_iOSPortfolioTasks")
        persistentContainer.loadPersistentStores(){(description, error) in
            if let error = error {
                fatalError("Failed to load core data stack: \(error)")
            }
        }
        childContext.parent = self.persistentContainer.viewContext
        super.init()
        if fetchAllIngredients().count == 0 {
            createDefaultIngredients()
        }
    }
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
        
    }
    
    func saveChildContext() {
        if childContext.hasChanges {
             do {
                 try childContext.save()
             } catch {
                 fatalError("Failed to save to Chidl Context CoreData: \(error)")
             }
         }
         
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allCocktailsFetchedResultsController { listeners.invoke { (listener) in
            if listener.listenerType == .cocktail || listener.listenerType == .all {
                    listener.onMyCocktailsChange(change: .update, myCocktails: fetchAllCocktails())
            }}
        }
    }
    
    //MARK: Database Protocol Functions
    
    func cleanup() {
        saveContext()
        saveChildContext()
    }
    
    // MARK: - Parent Context Functions
    func addCocktail(name: String, instructions: String) -> Cocktail {
        let cocktail = NSEntityDescription.insertNewObject(forEntityName: "Cocktail", into: persistentContainer.viewContext) as! Cocktail
        cocktail.name = name
        cocktail.instructions = instructions
        return cocktail
    }
    
    
    func addIngredientMeasurement(cocktail: Cocktail, ingredientName: String, measurement: String) -> IngredientMeasurement {
           let ingredientMeasurement = NSEntityDescription.insertNewObject(forEntityName: "IngredientMeasurement", into: persistentContainer.viewContext) as! IngredientMeasurement
           ingredientMeasurement.cocktails = cocktail
           ingredientMeasurement.name = ingredientName
           ingredientMeasurement.quantity = measurement
           
           return ingredientMeasurement
       }
    
    
    func addIngredient(name: String) -> Ingredient {
        let ingredient = NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: persistentContainer.viewContext) as! Ingredient
        ingredient.name = name
        return ingredient
    }
    
    func removeCocktail(cocktail: Cocktail) {
        persistentContainer.viewContext.delete(cocktail)
    }
    
    func removeIngredientFromCocktail(cocktail: Cocktail, ingredientMeasurement: IngredientMeasurement) {
        cocktail.removeFromIngredients(ingredientMeasurement)
    }
    

    // MARK: - Child Context Functions
    func editCocktail(cocktail: Cocktail) -> Cocktail {
        childContext.rollback()
        let childCocktail = childContext.object(with: cocktail.objectID) as! Cocktail
        return childCocktail
    }
    
    func createEmptyCocktail() -> Cocktail {
        childContext.rollback()
        let emptyCocktail = NSEntityDescription.insertNewObject(forEntityName: "Cocktail", into: childContext) as! Cocktail
        return emptyCocktail
    }
    
    func editCocktailName(cocktail: Cocktail, name: String) {
        cocktail.name = name
        return
    }
    
    func editCocktailInstructions(cocktail: Cocktail, instructions: String) {
        cocktail.instructions = instructions
        return
    }
    
    
    func editAddIngredientMeasurement(cocktail: Cocktail, ingredientName: String, measurement: String) -> IngredientMeasurement {
        let ingredientMeasurement = NSEntityDescription.insertNewObject(forEntityName: "IngredientMeasurement", into: childContext) as! IngredientMeasurement
        ingredientMeasurement.cocktails = cocktail
        ingredientMeasurement.name = ingredientName
        ingredientMeasurement.quantity = measurement
        return ingredientMeasurement
    }

    func editRemoveIngredientMeasurement(cocktail: Cocktail, ingredientMeasurement: IngredientMeasurement) {
        cocktail.removeFromIngredients(ingredientMeasurement)
        return
    }
    
    func editSaveCocktail(cocktail: Cocktail) {
        saveChildContext()
    }
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .cocktail || listener.listenerType == .all {
            listener.onMyCocktailsChange(change: .update, myCocktails: fetchAllCocktails())
        }
        
        if listener.listenerType == .ingredient || listener.listenerType == .all {
            listener.onIngredientsChange(change: .update, ingredients: fetchAllIngredients())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    // MARK: - Fetch All Functions
    func fetchAllCocktails() -> [Cocktail] {
        if allCocktailsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Cocktail> = Cocktail.fetchRequest()
            // sort it by name
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            //initialize the results controller
            allCocktailsFetchedResultsController = NSFetchedResultsController<Cocktail>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            // set this to be the results delegate
            allCocktailsFetchedResultsController?.delegate = self
            
            do {
                try allCocktailsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch request failed: \(error)")
            }
        }
        var cocktails = [Cocktail]()
        if allCocktailsFetchedResultsController?.fetchedObjects != nil {
            cocktails = (allCocktailsFetchedResultsController?.fetchedObjects)!
        }
        return cocktails
    }
    
    
    func fetchAllIngredients () -> [Ingredient] {
        if allIngredientsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allIngredientsFetchedResultsController = NSFetchedResultsController<Ingredient>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allIngredientsFetchedResultsController?.delegate = self
            do {
                try allIngredientsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch request failed: \(error)")
            }
        }
        var ingredients = [Ingredient]()
        if allIngredientsFetchedResultsController?.fetchedObjects != nil {
            ingredients = (allIngredientsFetchedResultsController?.fetchedObjects)!
        }
        return ingredients
    }
    
    

    
    // MARK: - Get Default Ingredients
    func createDefaultIngredients() {
        let searchString = INGREDIENTS_URL
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let task = URLSession.shared.dataTask(with: jsonURL!){(data, response, error) in
            if let error = error {
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let volumeData = try decoder.decode(DefaultIngredients.self, from: data!)
                for ingredients in volumeData.ingredients! {
                    let ingredient = NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: self.childContext) as! Ingredient
                    ingredient.name = ingredients.name
                    print(ingredient)
                }
                DispatchQueue.main.async {
                    self.saveChildContext()
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    
}
