//
//  CalendarioPagosViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/13/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

struct User: Codable {
    let id: String
    let id_user: String
    let concepto: String
    let fecha_pago : String
}

class CalendarioPagosViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
     private let refreshControl = UIRefreshControl()
    

    @IBOutlet weak var tabla: UITableView!
    
    
    let URL_HEROES = "http://ferlectronics.com/restful/index.php/Pruebasdb/fecha_pago";
    //A string array to save all the names
    var nameArray = [String]()
    
    @IBOutlet weak var fechaPagoLabel: UILabel!
    
     var usuarios = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.reloadData()
        
        
        getPagos()
        getDateJson()
        
        //refreshcontrol Actualizar nuevos entrenamientos
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        tabla.addSubview(refreshControl)
        view.bringSubviewToFront(refreshControl)
    }
    //refreshControl para actualizar pagos
    @objc private func reload(){
        //mostrarDatos()
        getPagos()
        getDateJson()
        tabla.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    func cargarNuevoPAgo(){
        tabla.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cargarNuevoPAgo()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = usuarios[indexPath.row]
        cell.textLabel?.text = user.concepto
        cell.detailTextLabel?.text = user.fecha_pago
        return cell
    }
    
    
    func getPagos(){
        guard let datos = URL(string: "http://ferlectronics.com/pagosgym/restful/index.php/Pruebasdb/fecha_pagos") else { return }
        let url = URLRequest(url: datos)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let response = response {
                print("Respuesta del server : \(response)")
            }
            
            do{
                self.usuarios = try JSONDecoder().decode([User].self, from: data!)
                
                DispatchQueue.main.async {
                    self.tabla.reloadData()
                }
            } catch let error as NSError{
                print("error al cargar", error.localizedDescription)
                
            }
        }.resume()
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
