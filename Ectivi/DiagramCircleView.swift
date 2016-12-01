//
//  DiagramCircleClass.swift
//  Ectivi
//
//  Created by Artem Misesin on 11/24/16.
//  Copyright © 2016 Artem Misesin. All rights reserved.
//
import UIKit

@IBDesignable
class DiagramCircleView: UIView {
    
    @IBInspectable
    private var scale: CGFloat = 0.9{ didSet { setNeedsDisplay() } }
    
    private var model = EctiviModel()
    
    @IBInspectable
    private var color: UIColor = UIColor(red: 0.93, green: 0.94, blue: 0.94, alpha: 1)
    
    @IBInspectable
    private var lineWidth: CGFloat = 2.0 { didSet { setNeedsDisplay() } }
        
    var circleRadius: CGFloat {
            return min(bounds.size.width, bounds.size.height) / 2 * scale
        }
    
    var circleCenter: CGPoint  {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    var ammount = 0{ didSet { setNeedsDisplay() } }
    
    private var graphicalAmmount: Int {
        return ammount / 20
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
            let path = UIBezierPath(
                arcCenter: midPoint,
                radius: radius,
                startAngle: 0,
                endAngle: CGFloat(2*M_PI),
                clockwise: false)
            path.lineWidth = lineWidth - 1.5
            return path
    }


    func degree2Radian(a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        pathForCircleCenteredAtPoint(midPoint: circleCenter, withRadius: circleRadius).stroke()
        color = UIColor.white
        color.set()
        pathForCircleCenteredAtPoint(midPoint: CGPoint(x: bounds.midX, y: bounds.midY), withRadius: circleRadius).fill()
        color = UIColor(red: 0.91, green: 0.91, blue: 0.94, alpha: 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()
        for entry in model.history[0].list {
            ammount += entry.ammount
        }
        let graphicalAmmount = ammount / 20
        drawTicks(context: ctx!, tickCount: 100, center: circleCenter, startRadius: circleRadius - 3, endRadius: circleRadius - 12, ticksToColor: graphicalAmmount)
        color = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1)
        color.set()
        pathForCircleCenteredAtPoint(midPoint: circleCenter, withRadius: circleRadius - 15).stroke()
        }
    private func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }
    
    func drawTicks(context: CGContext, tickCount: Int, center: CGPoint, startRadius: CGFloat, endRadius: CGFloat, ticksToColor: Int) {
        for i in 0 ... tickCount {
            let color: UIColor = i < ticksToColor ? UIColor(red: 0.49, green: 0.62, blue: 0.96, alpha: 1) : UIColor(red:0.90, green:0.91, blue:0.94, alpha:1.00)
            context.setStrokeColor(color.cgColor)
            let angle = .pi - degree2Radian(a: (CGFloat(360.0) / CGFloat(tickCount)) * CGFloat(i))
            let path = CGMutablePath()
            path.move(to: circleCircumferencePoint(center: center, angle: angle, radius: startRadius))
            path.addLine(to: circleCircumferencePoint(center: center, angle: angle, radius: endRadius))
            context.addPath(path)
            context.setLineWidth(lineWidth)
            context.strokePath()
        }
    }
    
    
    private func circleCircumferencePoint(center: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
        return CGPoint(x: radius * sin(angle) + center.x, y: radius * cos(angle) + center.y)
    }
}
