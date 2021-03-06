//
//  AgendarCitaViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/18/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

class AgendarCitaViewController: UIViewController {
    @IBOutlet weak var fechaCita: UITextField!
    @IBOutlet weak var mensajeFecha: UILabel!
    @IBOutlet weak var nombreCita: UITextField!
    
    //var fecha: String = " "
    
    
    
    lazy var datePicker: UIDatePicker = {
        
        let picker = UIDatePicker()
        
        picker.datePickerMode = .date
        
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        
        return picker
    }()
    
    lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

         fechaCita.inputView = datePicker
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    fechaCita.resignFirstResponder()
    return true
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        
        fechaCita.text = dateFormatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }



    @IBAction func agendarCita(_ sender: Any) {
        
        guard let fecha = nombreCita.text, nombreCita.text?.count != 0 else {
            
            mensajeFecha.isHidden = false
            mensajeFecha.text = "¡Introduce tu nombre!"
            return
        }
        guard let nombre = fechaCita.text, fechaCita.text?.count != 0 else {
            
            mensajeFecha.isHidden = false
            mensajeFecha.text = "¡Introduce una fecha!"
            return
        }
      
        let datos = "fecha=\(fechaCita.text!)&nombre_user=\(nombreCita.text!)"
        let url = URL(string: "http://ferlectronics.com/pagosgym/citas/registra.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = datos.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {//si existe un error se termina la funcion
                print("Error en el servidor")
                
                print("solicitud fallida \(String(describing: error))")
                return
            }
            
            do {//creamos nuestro objeto json
                
                print("recibimos respuesta")
                
                
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: String] {
                    
                    
                    DispatchQueue.main.async {//proceso principal
                        
                        let mensaje = json["mensaje"]
                        
                        // print(mensaje)
                        
                        if mensaje == "SI"{
                            print("Cita agendada exitoso")
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
                print("respuesta : \(String(describing: responseString))")
            }
        }
        task.resume()
        
        
        
        self.datePicker.endEditing(true)
        nombreCita.text = " "
        fechaCita.text = " "
        mensajeFecha.text = "¡Tu cita ha sido agendada!"
    }
}
