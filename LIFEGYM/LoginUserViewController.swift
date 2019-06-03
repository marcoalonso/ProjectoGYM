//
//  LoginUserViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 5/30/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

class LoginUserViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var password: UITextField!
    
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
    
}
