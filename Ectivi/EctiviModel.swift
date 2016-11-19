//
//  Model.swift
//  Ectivi
//
//  Created by Artem Misesin on 11/19/16.
//  Copyright © 2016 Artem Misesin. All rights reserved.
//

import Foundation

class EctiviModel {
    
    var goal = 2000
    
    var history: [[(time: String, ammount: Int)]] = [[("6.00 pm", 200), ("4.00 pm", 400), ("3.00 pm", 500)], [("8.00 pm", 200), ("6.00 pm", 400), ("12.00 pm", 500)]]
    
    var sections: [String] = ["Today", "Yesterday"]
    
    var total = 0
}
