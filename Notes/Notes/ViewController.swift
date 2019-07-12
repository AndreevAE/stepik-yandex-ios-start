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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var datePickerSwitcher: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var firstColorView: UIView!
    @IBOutlet weak var secondColorView: UIView!
    @IBOutlet weak var thirdColorView: UIView!
    @IBOutlet weak var customColorView: UIView!
    
    class Model {
        
        var title: String = ""
        var content: String = ""
        var color: UIColor = UIColor()
        var selfDestructionDate: Date?
        
    }
    
    private var model = Model()
    private var customColor = UIColor()
    
    @IBAction func switchDatePickerView(_ sender: UISwitch) {
        self.datePicker.isHidden = !sender.isOn
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        // TODO:
        print("\(sender.date)")
        self.model.selfDestructionDate = sender.date
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupView()
        DDLogInfo("ViewController didLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name:UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name:UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        
        
        // TODO: handle saving to let model
        
    }
    

    override var prefersStatusBarHidden: Bool {
        // WORKAROUND: uistatusbar received memory leak in background fix
        return true
    }

}

private extension ViewController {
    
    @objc func tapOnFirst(_ sender: UITapGestureRecognizer) {
        print("Tap First")
        // TODO: handle selection, draw check mark
        self.model.color = self.firstColorView.backgroundColor ?? UIColor.white
    }
    
    @objc func tapOnSecond(_ sender: UITapGestureRecognizer) {
        print("Tap Second")
        // TODO: handle selection, draw check mark
        self.model.color = self.secondColorView.backgroundColor ?? UIColor.red
    }
    
    @objc func tapOnThird(_ sender: UITapGestureRecognizer) {
        print("Tap Third")
        // TODO: handle selection, draw check mark
        self.model.color = self.thirdColorView.backgroundColor ?? UIColor.green
    }
    
    @objc func tapOnCustom(_ sender: UITapGestureRecognizer) {
        print("Tap Custom")
        // TODO: handle selection, draw check mark
        // TODO: color to Model
        
        self.model.color = self.customColor
    }
    
    @objc func longTapOnCustom(_ sender: UILongPressGestureRecognizer) {
        let colorPickerVC = ColorPickerViewController { [weak self] (selectedColor) in
            self?.model.color = selectedColor
        }
        
        self.present(colorPickerVC, animated: true, completion: nil)
    }
    
    func setupView() {
        self.datePickerSwitcher.isOn = false
        self.datePicker.isHidden = true
        
//        self.noteTextView.text = ""
        
        self.firstColorView.backgroundColor = .white
        self.secondColorView.backgroundColor = .red
        self.thirdColorView.backgroundColor = .green
        // TODO: custom pallete color
        
        let firstTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnFirst(_:)))
        let secondTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnSecond(_:)))
        let thirdTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnThird(_:)))
        let customTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnCustom(_:)))
        let customLongTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTapOnCustom(_:)))
        
        self.firstColorView.addGestureRecognizer(firstTapGestureRecognizer)
        self.secondColorView.addGestureRecognizer(secondTapGestureRecognizer)
        self.thirdColorView.addGestureRecognizer(thirdTapGestureRecognizer)
        self.customColorView.addGestureRecognizer(customTapGestureRecognizer)
        self.customColorView.addGestureRecognizer(customLongTapGestureRecognizer)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
}
