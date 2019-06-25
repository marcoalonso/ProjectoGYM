//
//  MenuEjerciciosViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 5/27/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

class MenuEjerciciosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "musculos.jpg"))

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "musculos.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    @IBAction func cierraSesion(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func salir(_ sender: UIBarButtonItem) {
        exit(0)
        //self.dismiss(animated: true, completion: nil)
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
