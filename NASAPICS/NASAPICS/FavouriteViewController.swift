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
    //@IBOutlet var Labeltext: UILabel!


    
    let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self , forCellReuseIdentifier:  "cell")
       return table
    }()
    
    private var models = [Favourite]()
    //table row an d cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LastViewController {
            destination.model = models[(tableView.indexPathForSelectedRow?.row)!  ]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "favourite Dates"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
      //fetchData()
        openDatabse()
        
    }
   
    
    func openDatabse()
       {
        
        
           context = appDelegate.persistentContainer.viewContext

           fetchData()


       }

    func fetchData()
    {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            models = try context.fetch(request) as! [Favourite]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            //tableView.reloadData()
            for data in result as! [NSManagedObject] {
                let Date = data.value(forKey: "date") as! String

                print("Favourite Date is : " + Date)
            }
        } catch {
            print("Fetching data Failed")
        }
    }





}



