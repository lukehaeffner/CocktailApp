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
        // Initialize the core data for parent and child contexts
        persistentContainer = NSPersistentContainer(name: "LUKEHAEFFNER_A2_iOSPortfolioTasks")
        persistentContainer.loadPersistentStores(){(description, error) in
            if let error = error {
                fatalError("Failed to load core data stack: \(error)")
            }
        }
        childContext.parent = self.persistentContainer.viewContext
        super.init()
        
        // if initial launch, add all default ingredients
        if fetchAllIngredients().count == 0 {
            createDefaultIngredients()
        }
    }
    
    /**
     Save the context aka write the data to CoreData
     */
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
        
    }
    
    /**
     Save the child context, aka for the changes in coredata, this will save them to the parent context
     */
    func saveChildContext() {
        if childContext.hasChanges {
             do {
                 try childContext.save()
             } catch {
                 fatalError("Failed to save to child Context CoreData: \(error)")
             }
         }
         
    }
    /**
     Alerting listeners that an event has occured
     */
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
    /**
     Adding a cocktail to the CoreData
     - Parameters:
        - name: The name of the cocktail
        - instructions: The written instructions of the cocktail
     - Returns:The Cocktail which has been added
     */
    func addCocktail(name: String, instructions: String) -> Cocktail {
        let cocktail = NSEntityDescription.insertNewObject(forEntityName: "Cocktail", into: persistentContainer.viewContext) as! Cocktail
        cocktail.name = name
        cocktail.instructions = instructions
        return cocktail
    }
    
    /**
     Add an IngredientMeasurement, given an already existing cocktail and the ingredient information to be added
     - Parameters:
        - cocktail: An already existing selected cocktail
        - ingredientName: The name of the ingredient
        - measurement: The quantity of ingredient to be added
     - Returns: The  IngredientMeasurement which has been added
     */
    func addIngredientMeasurement(cocktail: Cocktail, ingredientName: String, measurement: String) -> IngredientMeasurement {
           let ingredientMeasurement = NSEntityDescription.insertNewObject(forEntityName: "IngredientMeasurement", into: persistentContainer.viewContext) as! IngredientMeasurement
           ingredientMeasurement.cocktails = cocktail
           ingredientMeasurement.name = ingredientName
           ingredientMeasurement.quantity = measurement
           
           return ingredientMeasurement
       }
    
    /**
     Add a single ingredient to the CoreData, given its name
     - Parameters:
        - name: The name of the ingredient
     - Returns: The Ingredient which was added
     */
    func addIngredient(name: String) -> Ingredient {
        let ingredient = NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: persistentContainer.viewContext) as! Ingredient
        ingredient.name = name
        return ingredient
    }
    
    /**
     Remove a cocktail from CoreData
     - Parameters:
        - cocktail: The already existing cocktail in CoreData
     */
    func removeCocktail(cocktail: Cocktail) {
        persistentContainer.viewContext.delete(cocktail)
    }
    
    /**
     Remove an IngredientMeasurement from an existing cocktail, given both
    - Parameters:
        - cocktail: The cocktail to have an ingredient removed from
        - ingredientMeasurement: the measurement being removed
     */
    func removeIngredientFromCocktail(cocktail: Cocktail, ingredientMeasurement: IngredientMeasurement) {
        cocktail.removeFromIngredients(ingredientMeasurement)
    }
    

    // MARK: - Child Context Functions
    
    /**
     Discard previous childcontext objects and create an copy of a parent context cocktail, given the provided cocktail
     - Parameters:
        - cocktail: The cocktail being edited
     - Returns: A copy of the given cocktail, in the childcontext
     */
    func editCocktail(cocktail: Cocktail) -> Cocktail {
        childContext.rollback()
        let childCocktail = childContext.object(with: cocktail.objectID) as! Cocktail
        return childCocktail
    }
    
    /**
     Discard previous childcontext objects and create a blank Cocktail within the child context
     - Returns: A cocktail in the child context
     */
    func createEmptyCocktail() -> Cocktail {
        childContext.rollback()
        let emptyCocktail = NSEntityDescription.insertNewObject(forEntityName: "Cocktail", into: childContext) as! Cocktail
        return emptyCocktail
    }
    
    /**
     Edit the name for a given Cocktail within the child context
     - Parameters:
        - cocktail: The chosen cocktail
        - name: The new name of the cocktail
     */
    func editCocktailName(cocktail: Cocktail, name: String) {
        cocktail.name = name
        return
    }
    
    /**
     Edit the instructions for a given cocktail within the child context
     - Parameters:
        - cocktail: The chosen cocktail
        - instructions: The new instructions for the cocktail
     */
    func editCocktailInstructions(cocktail: Cocktail, instructions: String) {
        cocktail.instructions = instructions
        return
    }
    
    /**
     Add an IngredientMeasurement to a child context cocktail
     - Parameters:
        - cocktail: The given cocktail
        - ingredientName: The name of the ingredient
        - measurement: The quantity to be added to the ingredient
     */
    func editAddIngredientMeasurement(cocktail: Cocktail, ingredientName: String, measurement: String) -> IngredientMeasurement {
        let ingredientMeasurement = NSEntityDescription.insertNewObject(forEntityName: "IngredientMeasurement", into: childContext) as! IngredientMeasurement
        ingredientMeasurement.cocktails = cocktail
        ingredientMeasurement.name = ingredientName
        ingredientMeasurement.quantity = measurement
        return ingredientMeasurement
    }

    /**
     Remove an IngredientMeasurement to a child context cocktail
     - Parameters:
        - cocktail: The given cocktail
        - ingredientMeasurement: The IngredientMeasurement being removed
     */
    func editRemoveIngredientMeasurement(cocktail: Cocktail, ingredientMeasurement: IngredientMeasurement) {
        cocktail.removeFromIngredients(ingredientMeasurement)
        return
    }
    
    /**
    Save the child context created object
     TODO: Remove the need to supply the cocktail
     */
    func editSaveCocktail(cocktail: Cocktail) {
        saveChildContext()
    }
    
    /**
    Generate the different database listeners for the delegates to listen to
     */
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .cocktail || listener.listenerType == .all {
            listener.onMyCocktailsChange(change: .update, myCocktails: fetchAllCocktails())
        }
        
        if listener.listenerType == .ingredient || listener.listenerType == .all {
            listener.onIngredientsChange(change: .update, ingredients: fetchAllIngredients())
        }
    }
    
    /**
     Remove a database listener
     */
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    // MARK: - Fetch All Functions
    
    /**
     Return a list of all Cocktails currently in CoreData
     - Returns: An array of all Cocktails
     */
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
    
    
    /**
     Return a list of every ingredient currently in the database
     - Returns: An array of Ingredients
     */
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
    
    func fetchIngredientByName(ingredientName: String) -> [Ingredient]  {
        var ingredient: [Ingredient] = []
        let ingredientPredicate = NSPredicate(format: "name == %@", ingredientName)
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        fetchRequest.predicate = ingredientPredicate
        do {
            try ingredient = persistentContainer.viewContext.fetch(fetchRequest) as [Ingredient]
            print(ingredient)
        } catch {
            print("Fetch failed")
        }
        return ingredient
    }
    

    
    // MARK: - Get Default Ingredients
    /**
     Create a set of default ingredients that will only run on initial launch
     */
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
