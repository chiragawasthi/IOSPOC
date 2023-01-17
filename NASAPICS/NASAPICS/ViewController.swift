//
//  ViewController.swift
//  NASAPICS
//
//  Created by Gaurav Semwal on 13/01/23.
//  Copyright © 2023 Chirag Awasthi. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    //variable declaration
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    var context:NSManagedObjectContext!
  
    let datePicker = UIDatePicker()
    @IBOutlet var Imageapod: UIImageView!
    @IBOutlet var DescriptionText: UITextView!
    @IBOutlet var DateText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createDatePicker()
        
    }
    
    @IBAction func FAV(_ sender: Any) {
        let s = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteViewController") as! FavouriteViewController
        self.navigationController?.pushViewController(s, animated: true)
    }
    
   
    
    
    @IBAction func ADDTOFAVOURITE(_ sender: Any) {
        openDatabse()
    }
    // MARK: Methods to Open, Store and Fetch data
    func openDatabse()
    {
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favourite", in: context)
        let dateFav = NSManagedObject(entity: entity!, insertInto: context)
        //deletedate()
        saveData(Date: dateFav)
        
        
    }
    func deletedate(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(batchDeleteRequest)
            print(" Data deleted")

        } catch {
                   // Error Handling
            print("deleting Data..")
        }
    }
    
    func saveData(Date:NSManagedObject)
    {

        let str = String(DateText.text!)
        Date.setValue(str, forKey: "date")
        print("Storing Data..")
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }

        fetchData()
    }
    
    func fetchData()
    {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let Date = data.value(forKey: "date") as! String
                
                print("Favourite Date is : " + Date)
            }
        } catch {
            print("Fetching data Failed")
        }
    }
    
    
    
    
    //creating date picker
    func createDatePicker() {
        //creating tool bar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
       
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
         toolbar.setItems([doneBtn], animated: true)
        //asign toolbar
        DateText.inputAccessoryView = toolbar
        //assign datepicker to text field
        DateText.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    @objc func donePressed(){
        //formater
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        DateText.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        var baseurl = "https://api.nasa.gov/planetary/apod?api_key=tY7oOZ2bgCMkpM4Ddeq81f3ZW9CYnownhgp830th"
        let addDate = "&date="+formatter.string(from: datePicker.date)+"&"
        baseurl = baseurl + addDate
        let url = URL(string: baseurl)!
        
        
        
        let task = URLSession.shared.dataTask(with: url) { data,response, error in
            guard let data =  data else { return }
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let img = jsonData?["url"] as? String
            let desc = jsonData?["explanation"] as? String
            
            DispatchQueue.main.async{
                
                self.Imageapod.loadFrom(URLAddress: img!)
                self.DescriptionText.text = desc!
            }
        }
        
        task.resume()
        
    }
    
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}



