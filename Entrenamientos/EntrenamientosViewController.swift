//
//  EntrenamientosViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 5/31/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit
import CoreData

class EntrenamientosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    var entrenamientos = [Entrenamiento]()
    private let refreshControl = UIRefreshControl()
    
    
    func conexion()->NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabla.delegate = self
        tabla.dataSource = self
        
        mostrarDatos()
        
        //refreshcontrol Actualizar nuevos entrenamientos
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        tabla.addSubview(refreshControl)
        view.bringSubviewToFront(refreshControl)
        
    }
    
   @objc private func reload(){
        mostrarDatos()
        tabla.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entrenamientos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let entrenamiento = entrenamientos[indexPath.row]
        cell.textLabel?.text = entrenamiento.nombre
        cell.detailTextLabel?.text = entrenamiento.desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let contexto = conexion()
        let entrenamiento = entrenamientos[indexPath.row]
        if editingStyle == .delete {
            contexto.delete(entrenamiento)
            do {
                try contexto.save()
            } catch let error as NSError {
                print("Error al eliminar datos. ", error.localizedDescription)
            }
        }
        
        mostrarDatos()
        tabla.reloadData()
    }

    func mostrarDatos(){
        let contexto = conexion()
        let fetchRequest : NSFetchRequest<Entrenamiento> = Entrenamiento.fetchRequest()
        do {
            entrenamientos = try contexto.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error al mostrar datos. ", error.localizedDescription)
        }
    }

}
