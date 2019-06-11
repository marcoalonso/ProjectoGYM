//
//  RegistrarUsuarioViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 5/30/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit
import SQLite3

class RegistrarUsuarioViewController: UIViewController, UITextFieldDelegate {
    
    var db: OpaquePointer?
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var registrarBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegados
        usuario.delegate = self
        correo.delegate = self
        password.delegate = self
        nombre.delegate = self

        //Sqlite
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        usuario.inputAccessoryView = keyboardToolbar
        password.inputAccessoryView = keyboardToolbar
        nombre.inputAccessoryView = keyboardToolbar
        correo.inputAccessoryView = keyboardToolbar
        
        //abro base de datos
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("login.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("Error al abrir la base de datos")
        }
    }
    
    @IBAction func registrar(_ sender: Any) {
        
        //enviar datos a Login
        performSegue(withIdentifier: "enviarDatosLogin", sender: self)
            
    }
    
    //datos a enviar a Login
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviarDatosLogin"{
            let destino = segue.destination as! LoginUserViewController
            destino.recibirCorreo = correo.text
            destino.recibirPassword = password.text
        }
    }
        
    //ocultar teclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    @IBAction func registroLocal(_ sender: UIButton) {
        let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)
        
        var stmt: OpaquePointer?
        
        let query = "INSERT INTO usuarios(nombre,user,password,correo) VALUES(?,?,?,?)"
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK{
            print("Error al ejecutar query")
        }
        
        
        if sqlite3_bind_text(stmt, 1,nombre.text, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error nombre")
        }
        if sqlite3_bind_text(stmt, 2, usuario.text, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error usuario")
        }
        if sqlite3_bind_text(stmt, 3, password.text, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error contraseña")
        }
        if sqlite3_bind_text(stmt, 4, correo.text, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error correo")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            print("Registro exitoso")
            self.performSegue(withIdentifier: "login", sender: self)
        }
        
        usuario.text = ""
        password.text = ""
        nombre.text = ""
        correo.text = ""
        sqlite3_finalize(stmt)
        
        
    }
}
