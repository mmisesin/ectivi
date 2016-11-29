//
//  skTest.swift
//  Ectivi
//
//  Created by Artem Misesin on 11/24/16.
//  Copyright © 2016 Artem Misesin. All rights reserved.
//

import SpriteKit

class DiagramDots: SKShapeNode {
    func circleOfDots() {
        let radius: CGFloat = 100.0
        let numberOfCircle = 30
        for i in 0...numberOfCircle {
            
            let circle = SKShapeNode(circleOfRadius: 2 )
            circle.strokeColor = SKColor.clear
            circle.glowWidth = 1.0
            circle.fillColor = SKColor.orange
            // You can get every single circle by name:
            circle.name = String(format:"circle%d",i)
            let angle = 2 * M_PI / Double(numberOfCircle) * Double(i)
            
            let circleX = radius * cos(CGFloat(angle))
            let circleY = radius * sin(CGFloat(angle))
            
            circle.position = CGPoint(x:circleX + frame.midX, y:circleY + frame.midY)
            addChild(circle)
        }
    }
}
