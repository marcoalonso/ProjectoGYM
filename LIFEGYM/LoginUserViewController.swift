//
//  LoginUserViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 5/30/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit
import SQLite3

class LoginUserViewController: UIViewController, UITextFieldDelegate {
     var db: OpaquePointer?
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var tituloNombre: UILabel!
    
    var correoBD: String = ""
    
     let dataJsonUrlClass = JsonClass()
    
    //variables para recibir datos del registro
    var recibirCorreo:String!
    var recibirPassword:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegados para ocultar teclado
        correo.delegate = self
        password.delegate = self

        correo.text = recibirCorreo
        password.text = recibirPassword
        
        //SQlite
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        correo.inputAccessoryView = keyboardToolbar
        password.inputAccessoryView = keyboardToolbar
        
        
        
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
    
    //ocultar teclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func login(_ sender: UIButton) {
        
        
        //extraemos el valor del campo de texto (ID usuario)
        let Scorreo = correo.text
        let Spassword = password.text
        
        //si idText.text no tienen ningun valor terminamos la ejecución
        if Scorreo == "" || Spassword == ""{
            return
        }
        
        //Creamos un array (diccionario) de datos para ser enviados en la petición hacia el servidor remoto, aqui pueden existir N cantidad de valores
        let datos_a_enviar = ["correo": correo!, "password": password!] as NSMutableDictionary
        
        //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
        
        dataJsonUrlClass.arrayFromJson(url:"login.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
            DispatchQueue.main.async {//proceso principal
                
                /*
                 object(at: 0) as! NSDictionary -> indica que el elemento 0 de nuestro array lo vamos a convertir en un diccionario de datos.
                 */
                let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                
                //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                if (diccionario_datos.object(forKey: "error_mensaje") as! String?) != nil{
                    //self.errorLabel.text = errormensaje
                    
                    if let error = diccionario_datos.object(forKey: "error") as! Int?{
                        
                        if(error == 1){//registro exitoso, lo redirigimos a la view de inicio
                            
                            //instanciamos el viewcontroller "inicio" para enviar parametros y empujar la vista con "pushViewController"
                            let inicioVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
                            //inicioVc.nombre = diccionario_datos.object(forKey: "nombre") as! String
                            //inicioVc.correo = diccionario_datos.object(forKey: "correo") as! String
                            //inicioVc.id = diccionario_datos.object(forKey: "id") as! String
                            //inicioVc.pais = diccionario_datos.object(forKey: "pais") as! String
                            
                            self.navigationController?.pushViewController(inicioVc, animated: true)
                        }
                        
                    }
                }
                
                
                
            }
        }
    }
    @IBAction func loginLocal(_ sender: UIButton) {
        let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)
        let queryStatementString = "SELECT * FROM usuarios where user=? and password=?;"
        var queryStatement: OpaquePointer? = nil
        //let guardarCorreo: String
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            if sqlite3_bind_text(queryStatement, 1,correo.text, -1, SQLITE_TRANSIENT) != SQLITE_OK{
                print("Error nombre")
            }
            if sqlite3_bind_text(queryStatement, 2,password.text, -1, SQLITE_TRANSIENT) != SQLITE_OK{
                print("Error nombre")
            }
            
            
            
            if sqlite3_step(queryStatement) == SQLITE_ROW{
                
                
               
                let queryResultCol1 = sqlite3_column_text (queryStatement, 4 )
                let correo = String (cString: queryResultCol1!)
                
                self.performSegue(withIdentifier: "inicio", sender: self)
                
                correoBD = correo
                print(correoBD)
                tituloNombre.text=correoBD
                
            }
            else{
                self.performSegue(withIdentifier: "registro", sender: self)
            }
            
        } else {
            print("Sentencia SELECT no pudo ser preparada")
        }
        
        sqlite3_finalize(queryStatement)
       
        
        
       
        performSegue(withIdentifier: "enviar", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviar"{
            let destino = segue.destination as! InicioPruebaViewController
           
            
             destino.nombre2 = correoBD
            
            
        }
    }
    
}
