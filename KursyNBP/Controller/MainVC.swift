//
//  ViewController.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-10-27.
//

import UIKit

class MainVC: UIViewController {

    //Outletls
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var ratesDateLbl: UILabel!
    @IBOutlet weak var tableSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Vars
    private var currentTable: CurrencyTable = .a
    
    
    private var rowCount: Int = 0 {
        didSet {
            
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        setUpScreen()
    }

    private func setUpScreen() {

        refreshData()
      
        
    }
    
    
    
    @IBAction func refreshBtnPressed(_ sender: Any) {
        
        refreshData()
        
        
    }
    
    
    
    
    
    @IBAction func tableSegmentedControlChanged(_ sender: Any) {

        switch tableSegmentedControl.selectedSegmentIndex {
        case 1: currentTable = .b
        case 2: currentTable = .c
        default: currentTable = .a
        }
        
        refreshData()
    }
    
    
    private func reloadTable() {
        tableView.reloadData()
        
    }
    
    private func downloadData() {
        
        
        
    }
    
    
    private func refreshData() {
        activityIndicator.startAnimating()

        let net = Networking()
        net.fetchTable(table: currentTable) { result in
            if let result = result {
                
                do {
                    if self.currentTable != .c {
                        let decoded = try JSONDecoder().decode([ABTable].self, from: result)
                        DataService.instance.saveTableData(rawData: decoded[0])
                    } else {
                        let decoded = try JSONDecoder().decode([CTable].self, from: result)
                        DataService.instance.saveTableData(rawData: decoded[0])
                    }
                    
                    DispatchQueue.main.async {
                        self.reloadTable()
                        self.ratesDateLbl.text = DataService.instance.currencyDate
                        self.activityIndicator.stopAnimating()
                    }
                    
                } catch {
                    debugPrint("Error while decoding JSON data from API", error)
                }
                
                
                
            } else {
#warning("Add Error message")
            }
        }
    }
    
    
    
    
    
    
    
}




extension MainVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        print("You tapped cell number \(indexPath.row).")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
            
            vc.currency = DataService.instance.getOneCurrency(for: currentTable, at: indexPath.row)
            self.present(vc, animated: true)
        }
        
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.ratesCount(for: currentTable)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as? MainViewCell {
            guard let cellData = DataService.instance.getOneCurrency(for: currentTable, at: indexPath.item) else
            {
                return MainViewCell()
                
            }
            
            cell.updateView(currency: cellData)
            
            return cell
        }
        
        
        return MainViewCell()
    }
    
    
    
    
    
    
    
}

