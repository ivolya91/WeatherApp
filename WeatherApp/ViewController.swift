//
//  ViewController.swift
//  WeatherApp
//
//  Created by Olga Atlasova on 07/03/2019.
//  Copyright © 2019 Olga Atlasova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
   }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder() //убрать клавиатуру
        
        let urlString = "https://api.apixu.com/v1/current.json?key=6b73bc8a00984791b62140649190703&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))"
        let url = URL(string: urlString)
        
        var locationName: String?
        var temperature: Double?
        var errorHasOccured: Bool = false
        
        let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                if let _ = json["error"]  {
                    errorHasOccured = true
                }
                if let location = json["location"]  {
                    locationName = location["name"] as? String
                }
                if let current = json["current"]  {
                    temperature = current["temp_c"] as? Double
                }
                
                DispatchQueue.main.async {
                    
                    if errorHasOccured {
                        self?.cityLabel.text = "Error has occured"
                        self?.temperatureLabel.isHidden = true   //скрываем температуру
                    }
                    else {
                        self?.cityLabel.text = locationName
                        self?.temperatureLabel.text = "\(temperature!)"
                        self?.temperatureLabel.isHidden = false   //показываем температуру
                    }
                }
            
            }
            catch let jsonError {
                print(jsonError)
            }
            
        }

        task.resume()


    }
}

