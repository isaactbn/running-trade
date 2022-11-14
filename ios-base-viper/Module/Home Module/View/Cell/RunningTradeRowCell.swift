//
//  RunningTradeRowCell.swift
//  ios-base-viper
//
//  Created by Isaac on 11/2/22.
//

import UIKit

class RunningTradeRowCell: UITableViewCell {
    
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var chgLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var actLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var stockWidth: NSLayoutConstraint!
    @IBOutlet weak var priceWidth: NSLayoutConstraint!
    @IBOutlet weak var chgWidth: NSLayoutConstraint!
    @IBOutlet weak var volumeWidth: NSLayoutConstraint!
    @IBOutlet weak var actWidth: NSLayoutConstraint!
    @IBOutlet weak var timeWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupColumnWidth(value: CGFloat) {
        let view = [stockWidth, priceWidth, chgWidth, volumeWidth, actWidth, timeWidth]
        view.forEach{ (x) in
            if x == actWidth {
                x?.constant = (value/9) - 1
            } else if x == stockWidth {
                x?.constant = (value/3) - 1
            } else {
                x?.constant = (value/6) - 1
            }
        }
    }
    
}
