//
//  CalendarioPagosViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/13/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

class CalendarioPagosViewController: UIViewController {

    let URL_HEROES = "http://ferlectronics.com/restful/index.php/Pruebasdb/fecha_pago";
    //A string array to save all the names
    var nameArray = [String]()
    
    @IBOutlet weak var fechaPagoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        getDateJson();
    }
    
    func getDateJson(){
        //creating a NSURL
        let url = NSURL(string: URL_HEROES)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //printing the json in console
                //print(jsonObj.value(forKey: "pagos")!)
                
                //getting the avengers tag array from json and converting it to NSArray
                if let heroeArray = jsonObj.value(forKey: "pagos") as? NSArray {
                    //looping through all the elements
                    for heroe in heroeArray{
                        
                        //converting the element to a dictionary
                        if let heroeDict = heroe as? NSDictionary {
                            
                            //getting the name from the dictionary
                            if let name = heroeDict.value(forKey: "fecha_venc") {
                                
                                //adding the name to the array
                                self.nameArray.append((name as? String)!)
                            }
                            
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    //calling another function after fetching the json
                    //it will show the names to label
                    self.showNames()
                })
            }
        }).resume()
    }
    
    func showNames(){
        //looing through all the elements of the array
        for name in nameArray{
            
            //appending the names to label
            fechaPagoLabel.text = fechaPagoLabel.text! + name + "\n";
        }
    }

    

}
