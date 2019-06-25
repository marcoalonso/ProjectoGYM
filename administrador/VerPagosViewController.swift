//
//  VerPagosViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/24/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

struct Pagos: Codable {
    let id: String
    let fecha: String
    let nombre_user: String
}

class VerPagosViewController: UIViewController {
    
    var pagos = [Pagos]()

    override func viewDidLoad() {
        super.viewDidLoad()

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
