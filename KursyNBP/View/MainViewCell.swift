//
//  MainViewCell.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-10-29.
//

import UIKit

class MainViewCell: UITableViewCell {

    
    @IBOutlet weak var currencyNameLbl: UILabel!
    @IBOutlet weak var currencyCodeLbl: UILabel!
    @IBOutlet weak var currencyValueLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    func updateView(currency: Currency) {
        self.currencyNameLbl.text = currency.currency
        self.currencyCodeLbl.text =   "\(currency.multiplier) \(currency.code)"
        self.currencyValueLbl.text =  currency.value.formattedAmount
    }
    
    
    
}
