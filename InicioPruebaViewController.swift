//
//  InicioPruebaViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/8/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

class InicioPruebaViewController: UIViewController {
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var correo: UILabel!
    
    var correoRecibido: String!
    var nombre2: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //correo.text = correoRecibido
        nombre.text = nombre2

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
