//
//  InicioPruebaViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/8/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

class InicioPruebaViewController: UIViewController {
    @IBOutlet weak var nombreRecibido: UILabel!
    
    var recibirNombre: String!

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreRecibido.text = "Bienvenido: \(recibirNombre!)"
    
    }
    

    @IBAction func salirApp(_ sender: Any) {
        
        exit(0)
    }
    

}
