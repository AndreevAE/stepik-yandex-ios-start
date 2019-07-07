//
//  ViewController.swift
//  Notes
//
//  Created by Александр Андреев on 26/06/2019.
//  Copyright © 2019 Alexander Andreev. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ViewController: UIViewController {

    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var datePickerSwitcher: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var secondColorView: UIView!
    @IBOutlet weak var thirdColorView: UIView!
    @IBOutlet weak var customColorView: UIView!
    
    @IBAction func switchDatePickerView(_ sender: UISwitch) {
        self.datePicker.isHidden = !sender.isOn
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupView()
        DDLogInfo("ViewController didLoad")
    }

    override var prefersStatusBarHidden: Bool {
        // WORKAROUND: uistatusbar received memory leak in background fix
        return true
    }

}

private extension ViewController {
    
    func setupView() {
        self.datePickerSwitcher.isOn = false
        self.datePicker.isHidden = true
    }
}
