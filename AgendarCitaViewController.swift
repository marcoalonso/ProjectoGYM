//
//  AgendarCitaViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 6/18/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

class AgendarCitaViewController: UIViewController {

    @IBOutlet weak var mensajeReserva: UILabel!
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

    @IBAction func agendarCita(_ sender: Any) {
        mensajeReserva.text = "¡Tu cita ha sido agendada!"
    }
}
