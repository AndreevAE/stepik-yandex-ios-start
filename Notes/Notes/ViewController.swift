//
//  ViewController.swift
//  Notes
//
//  Created by Александр Андреев on 26/06/2019.
//  Copyright © 2019 Alexander Andreev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        // WORKAROUND: uistatusbar received memory leak in background fix
        return true
    }

}

