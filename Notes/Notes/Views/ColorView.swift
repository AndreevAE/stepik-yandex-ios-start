//
//  ColorView.swift
//  Notes
//
//  Created by Admin on 14/07/2019.
//  Copyright © 2019 Alexander Andreev. All rights reserved.
//

import UIKit

enum Color {
    case white
    case red
    case green
    case custom(UIColor?)
    
    func get() -> UIColor {
        switch self {
        case .white:
            return .white
        case .red:
            return .red
        case .green:
            return .green
        case .custom(let color):
            return color ?? .white
        }
    }
}

class ColorView: UIView {
    
    let elementSize: CGFloat = 1
    let saturationExponentTop:Float = 0.0
    let saturationExponentBottom:Float = 1.3
    
    var color = Color.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var brightness: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var checked = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        switch self.color {
        case .white, .red, .green:
            let color = self.color.get()
            color.setFill()
        case .custom(let color):
            if let color = color {
                color.setFill()
            } else {
                let height = rect.height
                let width = rect.width
                guard let context = UIGraphicsGetCurrentContext() else {
                    return
                }
                
                for y in stride(from: 0 , to: rect.height, by: elementSize) {
                    
                    var saturation = y < height / 2.0 ? CGFloat(2 * y) / height : 2.0 * CGFloat(height - y) / height
                    saturation = CGFloat(powf(Float(saturation), y < height / 2.0 ? saturationExponentTop : saturationExponentBottom))
//                    let brightness = y < height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(height - y) / height
                    
                    for x in stride(from: 0 , to: width, by: elementSize) {
                        let hue = x / width
                        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                        context.setFillColor(color.cgColor)
                        context.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
                    }
                }
            }
        }
        
        if checked {
            self.drawRectChecked(rect: rect)
        }
    }
    
    func getColorAtPoint(point: CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:self.elementSize * CGFloat(Int(point.x / self.elementSize)),
                                   y:self.elementSize * CGFloat(Int(point.y / self.elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? self.saturationExponentTop : self.saturationExponentBottom))
//        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}


private extension ColorView {
    
    func drawRectChecked(rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        
        let checkmarkBlue = UIColor.black
        
        let group = CGRect(x: rect.minX + 3,
                           y: rect.minY + 3,
                           width: rect.width * 0.33,
                           height: rect.height * 0.33)
        
        let checkedOvalPath = UIBezierPath(ovalIn: CGRect(x: group.minX + floor(group.width * 0.0 + 0.5),
                                                          y: group.minY + floor(group.height * 0.0 + 0.5),
                                                          width: floor(group.width * 1.0 + 0.5) - floor(group.width * 0.0 + 0.5),
                                                          height: floor(group.height * 1.0 + 0.5) - floor(group.height * 0.0 + 0.5)))
        
        context.saveGState()
        checkmarkBlue.setFill()
        checkedOvalPath.fill()
        context.restoreGState()
        
        UIColor.white.setStroke()
        checkedOvalPath.lineWidth = 1
        checkedOvalPath.stroke()
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: group.minX + 0.27083 * group.width,
                                    y: group.minY + 0.54167 * group.height))
        bezierPath.addLine(to: CGPoint(x: group.minX + 0.41667 * group.width,
                                       y: group.minY + 0.68750 * group.height))
        bezierPath.addLine(to: CGPoint(x: group.minX + 0.75000 * group.width,
                                       y: group.minY + 0.35417 * group.height))
        bezierPath.lineCapStyle = CGLineCap.square
        
        UIColor.white.setStroke()
        bezierPath.lineWidth = 1.3
        bezierPath.stroke()
    }
}
