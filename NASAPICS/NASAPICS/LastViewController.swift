//
//  LastViewController.swift
//  NASAPICS
//
//  Created by Gaurav Semwal on 17/01/23.
//  Copyright © 2023 Chirag Awasthi. All rights reserved.
//

import UIKit
import CoreData
class LastViewController: UIViewController {
    var model: Favourite!
    @IBOutlet var LabelTop: UILabel!
    @IBOutlet var DescText: UITextView!
    @IBOutlet var ImageAPOD: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        LoadImage()
        LabelTop.text = model.date
//        DescText.text = model.date
        
    }
    func LoadImage()
    {
        var baseurl = "https://api.nasa.gov/planetary/apod?api_key=tY7oOZ2bgCMkpM4Ddeq81f3ZW9CYnownhgp830th"
        let addDate = "&date="+model.date!+"&"
        baseurl = baseurl + addDate
        let url = URL(string: baseurl)!
        
        
        
        let task = URLSession.shared.dataTask(with: url) { data,response, error in
            guard let data =  data else { return }
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let img = jsonData?["url"] as? String
            let desc = jsonData?["explanation"] as? String
            
            DispatchQueue.main.async{
                
                self.ImageAPOD.loadFrom(URLAddress: img!)
                self.DescText.text = desc!
            }
        }
        
        task.resume()
    }

}
