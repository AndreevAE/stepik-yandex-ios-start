//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Александр Андреев on 12/07/2019.
//  Copyright © 2019 Alexander Andreev. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var colorPalleteView: UIView!
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var selectedColorLabel: UILabel!
    
    @IBAction func brightnessSliderValueChanged(_ sender: UISlider) {
        
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        self.handler?(self.selectedColor)
        self.dismiss(animated: true, completion: nil)
    }
    
    private var handler: ((UIColor) -> Void)?
    private var selectedColor = UIColor()
    
    init(handler: ((UIColor) -> Void)? = nil) {
        self.handler = handler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
