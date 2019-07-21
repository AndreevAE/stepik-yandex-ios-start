//
//  NoteEditorViewController.swift
//  Notes
//
//  Created by Admin on 21/07/2019.
//  Copyright © 2019 Alexander Andreev. All rights reserved.
//

import UIKit
import CocoaLumberjack

class NoteEditorViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var datePickerSwitcher: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var firstColorView: ColorView!
    @IBOutlet weak var secondColorView: ColorView!
    @IBOutlet weak var thirdColorView: ColorView!
    @IBOutlet weak var customColorView: ColorView!
    
    class Model {
        
        var uid: String = ""
        var title: String = ""
        var content: String = ""
        var color: UIColor = UIColor()
        var selfDestructionDate: Date?
        
    }
    
    private let savingHandler: (Note) -> Void
    private var model = Model()
    private var customColor = UIColor()
    
    @IBAction func switchDatePickerView(_ sender: UISwitch) {
        self.datePicker.isHidden = !sender.isOn
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        self.model.selfDestructionDate = sender.date
    }
    
    init(initNote: Note, savingHandler: @escaping (Note) -> Void) {
        self.model.uid = initNote.uid
        self.model.title = initNote.title
        self.model.content = initNote.content
        self.model.color = initNote.color
        self.model.selfDestructionDate = initNote.selfDestructionDate
        
        self.savingHandler = savingHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupView()
        self.setupNavigationBar()
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
        
        self.noteTitleTextField.text = self.model.title
        self.noteTextView.text = self.model.content
        // TODO: color
        self.customColor = self.model.color
        self.datePicker.date = self.model.selfDestructionDate ?? Date()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        
    }
    
}

private extension NoteEditorViewController {
    
    func check(colorView: ColorView) {
        _ = [self.firstColorView,
             self.secondColorView,
             self.thirdColorView,
             self.customColorView].filter { $0.color.get() != colorView.color.get() }.map { $0.checked = false }
        
        colorView.checked = true
    }
    
    @objc func tapOnFirst(_ sender: UITapGestureRecognizer) {
        print("Tap First")
        self.check(colorView: self.firstColorView)
        self.model.color = self.firstColorView.color.get()
    }
    
    @objc func tapOnSecond(_ sender: UITapGestureRecognizer) {
        print("Tap Second")
        self.check(colorView: self.secondColorView)
        self.model.color = self.secondColorView.color.get()
    }
    
    @objc func tapOnThird(_ sender: UITapGestureRecognizer) {
        print("Tap Third")
        self.check(colorView: self.thirdColorView)
        self.model.color = self.thirdColorView.color.get()
    }
    
    @objc func tapOnCustom(_ sender: UITapGestureRecognizer) {
        print("Tap Custom")
        
        self.check(colorView: self.customColorView)
        self.model.color = self.customColorView.color.get()
    }
    
    @objc func longTapOnCustom(_ sender: UILongPressGestureRecognizer) {
        let colorPickerVC = ColorPickerViewController { [weak self] (selectedColor) in
            self?.customColorView.color = .custom(selectedColor)
            self?.model.color = selectedColor
        }
        
        self.present(colorPickerVC, animated: true, completion: nil)
    }
    
    func setupView() {
        self.datePickerSwitcher.isOn = false
        self.datePicker.isHidden = true
        
        //        self.noteTextView.text = ""
        
        self.firstColorView.color = .white
        self.secondColorView.color = .red
        self.thirdColorView.color = .green
        self.customColorView.color = .custom(nil)
        
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
    
    func setupNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(onSave))
        
    }
    
    @objc func onCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onSave() {
        let note = Note(uid: self.model.uid,
                        title: self.noteTitleTextField.text ?? "",
                        content: self.noteTextView.text,
                        color: self.model.color,
                        importance: .regular,
                        selfDestructionDate: self.model.selfDestructionDate)
        self.savingHandler(note)
        self.navigationController?.popViewController(animated: true)
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
