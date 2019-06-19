//
//  InicioPruebaViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/8/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

class InicioPruebaViewController: UIViewController {
    
    @IBOutlet weak var bienvenida: UILabel!
    
    var usuario:String = ""
    var correo:String = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    

    @IBAction func salirApp(_ sender: Any) {
        
        exit(0)
    }
    

}
