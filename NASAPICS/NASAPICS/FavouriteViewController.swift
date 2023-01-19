//
//  FavouriteViewController.swift
//  NASAPICS
//
//  Created by Gaurav Semwal on 14/01/23.
//  Copyright © 2023 Chirag Awasthi. All rights reserved.
//
import UIKit
import CoreData

class FavouriteViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    //variable declaration
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    var context:NSManagedObjectContext!

    //creating table view
    let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self , forCellReuseIdentifier:  "cell")
       return table
    }()
    
    //creating variable of table favourite
    private var models = [Favourite]()
    
    //table row return number or rows in model
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    //table cell will return what the cell will contain in the row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.date
        return cell
    }
    
    //this function creates a navigation for every row by clicking them
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    //sending the value of that particular row to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LastViewController {
            destination.model = models[(tableView.indexPathForSelectedRow?.row)!  ]
        }
    }
    
    //main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating table on this view
        title = "favourite Dates"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        //calling function openDatabse
        openDatabse()
    }
   
    //this function creates context to intract with core data
    func openDatabse()
    {
           context = appDelegate.persistentContainer.viewContext
            
           //calling the fetch data function
           fetchData()
    }

    //this function fetches the data from the core data table "favourite"
    func fetchData()
    {
        print("Fetching Data..")
        
        //create instance to fetch data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        
        //this line will ensures that all the data is loaded from the persistent store and the fetch request returns full objects.
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            //we assign the models with the value that is fetched from the favourites table
            models = try context.fetch(request) as! [Favourite]
            
            //reloading the table after getting the data from the api
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            //checking if the data is fetched successfully on the output window
            for data in result as! [NSManagedObject] {
                let Date = data.value(forKey: "date") as! String

                print("Favourite Date is : " + Date)
            }
        } catch {
            print("Fetching data Failed")
        }
    }
    //end of fetchData()
}
