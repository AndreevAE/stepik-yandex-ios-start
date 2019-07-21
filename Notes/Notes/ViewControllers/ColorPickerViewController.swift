//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Александр Андреев on 12/07/2019.
//  Copyright © 2019 Alexander Andreev. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var colorPalleteView: ColorView!
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var selectedColorLabel: UILabel!
    
    @IBAction func brightnessSliderValueDidChanged(_ sender: UISlider) {
        self.colorPalleteView.brightness = CGFloat(sender.value)
    }
    
    @IBAction func brightnessSliderValueChanged(_ sender: UISlider) {
//        self.colorPalleteView.brightness = CGFloat(sender.value)
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        self.handler?(self.selectedColor)
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    private var handler: ((UIColor) -> Void)?
    private var selectedColor = UIColor.gray {
        didSet {
            self.selectedColorView.backgroundColor = selectedColor
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            if selectedColor.getRed(&r, green: &g, blue: &b, alpha: &a) &&
                !r.isNaN &&
                !g.isNaN &&
                !b.isNaN &&
                !a.isNaN {
                let gLabel = String(Int(r * 255.0), radix: 16, uppercase: false)
                let rLabel = String(Int(g * 255.0), radix: 16, uppercase: false)
                let bLabel = String(Int(b * 255.0), radix: 16, uppercase: false)
                self.selectedColorLabel.text = "#\(rLabel)\(gLabel)\(bLabel)"
            }
        }
    }
    
    init(handler: ((UIColor) -> Void)? = nil) {
        self.handler = handler
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.colorPalleteView.color = .custom(nil)
        
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchedColor(_ :)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat(Float.greatestFiniteMagnitude)
        self.colorPalleteView.addGestureRecognizer(touchGesture)
        // Do any additional setup after loading the view.
    }

    @objc func touchedColor(_ gestureRecognizer: UILongPressGestureRecognizer){
        let point = gestureRecognizer.location(in: self.colorPalleteView)
        let color = self.colorPalleteView.getColorAtPoint(point: point)
        
        self.selectedColor = color
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
