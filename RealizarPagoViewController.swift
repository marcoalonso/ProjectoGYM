//
//  RealizarPagoViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/17/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

class RealizarPagoViewController: UIViewController {
    @IBOutlet weak var montoPago: UILabel!
    @IBOutlet weak var conceptoText: UITextField!
    
    let currentDateTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        conceptoText.inputAccessoryView = keyboardToolbar
        
        

        // Do any additional setup after loading the view.
        print(currentDateTime)
    }
    @IBAction func pagar(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Realizar pago por", message: " \(montoPago.text!)", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.realizarPago()
            self.conceptoText.text=""
            self.montoPago.text="Pago Exitoso!"
            
        }))
    }
  
    
    func realizarPago(){
        let datos = "id_user=3&concepto=\(conceptoText.text!)&fecha_pago=\(currentDateTime)"
        let url = URL(string: "http://ferlectronics.com/pagosgym/nuevopago/registra.php")!
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
                            print("Pago exitoso")
                            //self.performSegue(withIdentifier: "login", sender: self)
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

  

}
