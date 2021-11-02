//
//  DetailABViewCell.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-10-29.
//

import UIKit

class DetailABViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateView(histData: CurrencyHist) {
        self.dateLbl.text = histData.date
        self.valueLbl.text = histData.mid.formattedAmount
    }
    
    
}
