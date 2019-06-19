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
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var mensajeError: UILabel!
    
    var db: OpaquePointer?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mensajeError.isHidden = true
        
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
    
    @IBAction func registroLocal(_ sender: Any) {
        guard let _ = nombre.text, nombre.text?.count != 0 else {
            
            mensajeError.isHidden = false
            mensajeError.text = "¡Introduce un nombre!"
            return
        }
        guard let _ = usuario.text, usuario.text?.count != 0 else {
            
            mensajeError.isHidden = false
            mensajeError.text = "¡Introduce un usuario!"
            return
        }
        guard let _ = correo.text, correo.text?.count != 0 else {
            
            mensajeError.isHidden = false
            mensajeError.text = "¡Introduce un correo!"
            return
        }
        guard let _ = password.text, password.text?.count != 0 else {
            
            mensajeError.isHidden = false
            mensajeError.text = "¡Introduce una contraseña!"
            return
        }
        
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
            mensajeError.isHidden = false
            mensajeError.text = "Registro exitoso"
            //print("Registro exitoso")
            self.performSegue(withIdentifier: "login", sender: self)
        }
        
        usuario.text = ""
        password.text = ""
        nombre.text = ""
        correo.text = ""
        sqlite3_finalize(stmt)
    }
    
    
    
    
    
    @IBAction func registroRemoto(_ sender: Any) {
        guard let _ = nombre.text, nombre.text?.count != 0 else {
            
            mensajeError.isHidden = false
            mensajeError.text = "¡Introduce un nombre!"
            return
        }
        guard let _ = usuario.text, usuario.text?.count != 0 else {
            
            mensajeError.isHidden = false
            mensajeError.text = "¡Introduce un usuario!"
            return
        }
        guard let _ = correo.text, correo.text?.count != 0 else {
            
            mensajeError.isHidden = false
            mensajeError.text = "¡Introduce un correo!"
            return
        }
        guard let _ = password.text, password.text?.count != 0 else {
            
            mensajeError.isHidden = false
            mensajeError.text = "¡Introduce una contraseña!"
            return
        }
        
        let datos = "usuario=\(usuario.text!)&contra=\(password.text!)&nombre=\(nombre.text!)&correo=\(correo.text!)"
        let url = URL(string: "http://ferlectronics.com/gymlogin/login/registra.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = datos.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {//si existe un error se termina la funcion
                print("Error en el servidor")
                
                print("solicitud fallida \(error)")
                return
            }
            
            do {//creamos nuestro objeto json
                
                print("recibimos respuesta")
                
                
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: String] {
                    
                    
                    DispatchQueue.main.async {//proceso principal
                        
                        let mensaje = json["mensaje"]
                        
                        // print(mensaje)
                        
                        if mensaje == "SI"{
                            self.mensajeError.isHidden = false
                            self.mensajeError.text = "Registro exitoso"
                            print("Registro exitoso")
                            self.performSegue(withIdentifier: "login", sender: self)
                        }
                        else if mensaje == "Repetido"{
                            self.mensajeError.isHidden = false
                            self.mensajeError.text = "El usuario ya existe"
                            //print("usuario ya existente, ingrese otro")
                            self.usuario.text = ""
                        }
                        else{
                            print("Algo salió mal")
                        }
                        
                        
                    }
                }
                
            } catch let parseError {//manejamos el error
                print("error al parsear: \(parseError)")
                print("Erro del servidor (JSON)")
                
                let responseString = String(data: data, encoding: .utf8)
                print("respuesta : \(responseString)")
            }
        }
        task.resume()
    }
    
    @IBAction func irLogin(_ sender: Any) {
         self.dismiss(animated: true, completion: nil )
    }
    
    
}
