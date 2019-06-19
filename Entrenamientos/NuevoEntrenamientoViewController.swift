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
    @IBOutlet weak var mensajeGuardar: UILabel!
    
    
    
    func conexion()->NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        nombre.inputAccessoryView = keyboardToolbar
        descripcion.inputAccessoryView = keyboardToolbar
       
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
            mensajeGuardar.text = "¡Guardado correctamente!"
            print("Se guardo correctamente")
        } catch let error as NSError{
            print("Error al guardar", error.localizedDescription)
        }
    }
    

   

}
