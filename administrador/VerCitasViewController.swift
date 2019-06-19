//
//  VerCitasViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/19/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

struct Citas: Codable {
    let id: String
    let id_user: String
    let concepto: String
    let fecha_pago : String
}

class VerCitasViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tablaCitas: UITableView!
    
    var usuarios = [Citas]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        obtenerCitas()

        // Do any additional setup after loading the view.
    }
    func obtenerCitas(){
        
        guard let datos = URL(string: "http://ferlectronics.com/pagosgym/restful/index.php/Pruebasdb/fecha_pagos") else { return }
        let url = URLRequest(url: datos)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let response = response {
                print("Respuesta del server : \(response)")
            }
            
            do{
                self.usuarios = try JSONDecoder().decode([Citas].self, from: data!)
                
                DispatchQueue.main.async {
                    self.tablaCitas.reloadData()
                }
            } catch let error as NSError{
                print("error al cargar", error.localizedDescription)
                
            }
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablaCitas.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = usuarios[indexPath.row]
        cell.textLabel?.text = user.concepto
        cell.detailTextLabel?.text = user.fecha_pago
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
