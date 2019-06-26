//
//  VerPagosViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/24/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

struct Pagos: Codable {
    let id: String
    let id_user: String
    let concepto: String
    let fecha_pago: String
}

class VerPagosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tablaPagos: UITableView!
    
    var pagos = [Pagos]()

    override func viewDidLoad() {
        super.viewDidLoad()

        obtenerPagos()
    }
    
    func obtenerPagos(){
        
        guard let datos = URL(string: "http://ferlectronics.com/pagosgym/restful/index.php/Pruebasdb/pagos") else { return }
        let url = URLRequest(url: datos)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let response = response {
                print("Respuesta del server : \(response)")
            }
            
            do{
                self.pagos = try JSONDecoder().decode([Pagos].self, from: data!)
                
                DispatchQueue.main.async {
                    self.tablaPagos.reloadData()
                }
            } catch let error as NSError{
                print("error al cargar", error.localizedDescription)
                
            }
            }.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pagos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablaPagos.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pago = pagos[indexPath.row]
        cell.textLabel?.text = pago.concepto
        cell.detailTextLabel?.text = pago.fecha_pago
        return cell
    }

    

}
