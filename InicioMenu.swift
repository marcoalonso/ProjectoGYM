//
//  InicioMenu.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/26/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

class InicioMenu: UIViewController {
    @IBOutlet weak var recibirNombre: UILabel!
    
    var nombreRecibido: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        //recibirNombre.text = "Bienvenido: \(nombreRecibido!)"
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
