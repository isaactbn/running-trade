//
//  StockListCell.swift
//  ios-base-viper
//
//  Created by Isaac on 11/14/22.
//

import UIKit

class StockListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var sLabel: UILabel!
    @IBOutlet weak var mLabel: UILabel!
    @IBOutlet weak var lLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
