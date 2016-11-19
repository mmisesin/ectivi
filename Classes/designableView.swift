//
//  designableView.swift
//  Ectivi
//
//  Created by Artem Misesin on 10/19/16.
//  Copyright © 2016 Artem Misesin. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
}
