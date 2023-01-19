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
    
    //main function
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
    }
    
    //this button action navigates us to the favouriteViewController
    @IBAction func FAV(_ sender: Any) {
        let s = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteViewController") as! FavouriteViewController
        self.navigationController?.pushViewController(s, animated: true)
    }
    
    //this button action calls the opendatabse() function
    @IBAction func ADDTOFAVOURITE(_ sender: Any) {
        openDatabse()
    }
    
    //this function creates the context to access the core data and then callls the savedata function
    func openDatabse()
    {
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favourite", in: context)
        let dateFav = NSManagedObject(entity: entity!, insertInto: context)
        //deletedate()
        saveData(Date: dateFav)
        
        
    }
    
    //this function if called can delete all the data of the core data database
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
    
    //saving data in in core data
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
    
    //function that runs after the done button is pressed
    @objc func donePressed(){
        //formater
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        DateText.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        //initialising variables and setting the URL
        var baseurl = "https://api.nasa.gov/planetary/apod?api_key=tY7oOZ2bgCMkpM4Ddeq81f3ZW9CYnownhgp830th"
        let addDate = "&date="+formatter.string(from: datePicker.date)+"&"
        baseurl = baseurl + addDate
        let url = URL(string: baseurl)!
        
        //Calling the API Using URL sessions
        let task = URLSession.shared.dataTask(with: url) { data,response, error in
            guard let data =  data else { return }
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let img = jsonData?["url"] as? String
            let desc = jsonData?["explanation"] as? String
            
            //load image and description on ui asynchronously on the main thread
            DispatchQueue.main.async{
                self.Imageapod.loadFrom(URLAddress: img!)
                self.DescriptionText.text = desc!
            }
        }
        task.resume()
    }
    //end of donePressed function
}

//creating extension for the UIImageView to load the data in the UIView
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
