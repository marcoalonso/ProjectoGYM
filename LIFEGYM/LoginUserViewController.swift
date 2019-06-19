//
//  LoginUserViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 5/30/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit
import SQLite3

class LoginUserViewController: UIViewController {
    
    var db: OpaquePointer?
    var correo:String = ""

    
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var mensajeError: UILabel!
    
        
    @IBAction func ingresarRemoto(_ sender: Any) {
        //valida campos vacio
        guard let email = usuario.text, usuario.text?.count != 0 else {
            
            mensajeError.isHidden = false
            mensajeError.text = "¡Introduce tu usuario!"
            return
        }
        guard let contraseña = password.text, password.text?.count != 0 else {
            
            mensajeError.isHidden = false
            mensajeError.text = "¡Introduce tu contraseña!"
            return
        }
      
        
        let datos = "usuario=\(usuario.text!)&contra=\(password.text!)"
        let url = URL(string: "http://ferlectronics.com/gymlogin/login/login.php")!
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
                        
                        //print(mensaje)
                        
                        if mensaje == "SI"{
                            let datos = "usuario=\(self.usuario.text!)"
                            let url = URL(string: "http://ferlectronics.com/gymlogin/login/mandar.php")!
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
                                            self.correo = mensaje!
                                            
                                            self.performSegue(withIdentifier: "inicio", sender: self)
                                            print(mensaje!)
                                            
                                            
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
                        else{
                            self.performSegue(withIdentifier: "registro", sender: self)
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
    
    
    @IBAction func ingresarLocal(_ sender: Any) {
        guard let email = usuario.text, usuario.text?.count != 0 else {
            
            mensajeError.isHidden = false
            mensajeError.text = "¡Introduce tu usuario!"
            return
        }
        guard let contraseña = password.text, password.text?.count != 0 else {
            
            mensajeError.isHidden = false
            mensajeError.text = "¡Introduce tu contraseña!"
            return
        }
        
        if((usuario.text == "admingym") && (password.text == "qwerty")){
            
            self.performSegue(withIdentifier: "admin", sender: self)
        } else {
        
        let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)
        let queryStatementString = "SELECT *FROM usuarios where user=? and password=?;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            if sqlite3_bind_text(queryStatement, 1,usuario.text, -1, SQLITE_TRANSIENT) != SQLITE_OK{
                print("Error nombre")
            }
            if sqlite3_bind_text(queryStatement, 2,password.text, -1, SQLITE_TRANSIENT) != SQLITE_OK{
                print("Error nombre")
            }
            
            
            if sqlite3_step(queryStatement) == SQLITE_ROW{
                
                self.performSegue(withIdentifier: "inicioLocal", sender: self)
            }
            else{
                self.performSegue(withIdentifier: "registro", sender: self)
            }
            
            
        } else {
            print("Sentencia SELECT no pudo ser preparada")
        }
        
        sqlite3_finalize(queryStatement)
        }
    } //fin del else para administrador
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //label msj campos vacios
        mensajeError.isHidden = true
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        usuario.inputAccessoryView = keyboardToolbar
        password.inputAccessoryView = keyboardToolbar
        
        
        //sqlite
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("login.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("Error al abrir la base de datos")
        }
        
        let create = "CREATE TABLE IF NOT EXISTS usuarios(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT,user TEXT, password TEXT, correo TEXT)"
        
        
        if sqlite3_exec(db, create, nil, nil, nil) != SQLITE_OK {
            print("Error al crear la tabla")
        }else{
            print("creada")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registro" {
            var vc = segue.destination as! RegistrarUsuarioViewController
        } else if segue.identifier == "inicioLocal" {
            var vc = segue.destination as! InicioPruebaViewController
            
            
        }
    }
    
}
