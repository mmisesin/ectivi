//
//  CustomTableViewCell.swift
//  Ectivi
//
//  Created by Artem Misesin on 11/12/16.
//  Copyright © 2016 Artem Misesin. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var ammount: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
