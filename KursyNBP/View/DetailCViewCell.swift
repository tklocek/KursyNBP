//
//  DetailCViewCell.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-11-02.
//

import UIKit

class DetailCViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var midValueLbl: UILabel!
    @IBOutlet weak var bidValueLbl: UILabel!
    @IBOutlet weak var askValueLbl: UILabel!
    
    
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
        self.askValueLbl.text = histData.ask?.formattedAmount ?? "0.0000"
        self.bidValueLbl.text = histData.bid?.formattedAmount ?? "0.0000"
        self.midValueLbl.text = histData.mid.formattedAmount
    }

}
