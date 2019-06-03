//
//  NuevoEntrenamientoViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 5/31/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit
import CoreData


class NuevoEntrenamientoViewController: UIViewController {
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var descripcion: UITextField!
    
    
    
    func conexion()->NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    
    @IBAction func guardar(_ sender: UIButton) {
        let contexto = conexion()
        let entidadEntrenamientos = NSEntityDescription.insertNewObject(forEntityName: "Entrenamiento", into: contexto) as! Entrenamiento
        entidadEntrenamientos.nombre = nombre.text
        entidadEntrenamientos.desc = descripcion.text
        
        do {
            try contexto.save()
            nombre.text = ""
            descripcion.text = ""
            print("Se guardo correctamente")
        } catch let error as NSError{
            print("Error al guardar", error.localizedDescription)
        }
    }
    

   

}
