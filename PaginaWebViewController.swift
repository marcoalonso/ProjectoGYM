//
//  PaginaWebViewController.swift
//  LIFEGYM
//
//  Created by marco alonso on 5/25/19.
//  Copyright © 2019 marco alonso. All rights reserved.
//

import UIKit

class PaginaWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlPagWeb = URL(string: "https://www.smartfit.com.mx/")

        webView.loadRequest(URLRequest(url: urlPagWeb!))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Menu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
