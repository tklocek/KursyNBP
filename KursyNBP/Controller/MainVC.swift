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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshData()
    }
    
    
    @IBAction func refreshBtnPressed(_ sender: Any) {
        DataService.instance.clearData(for: currentTable)
        reloadTable()
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
        Networking.fetchTable(table: currentTable) { result in
            switch result{
            case .failure(let error):
                ShowError.alert(title: "Niezidentyfikowany błąd sieciowy", message: error.localizedDescription, self)
            case .success(let data):
                do {
                    if self.currentTable != .c {
                        let decoded = try JSONDecoder().decode([ABTable].self, from: data)
                        DataService.instance.saveTableData(rawData: decoded[0])
                    } else {
                        let decoded = try JSONDecoder().decode([CTable].self, from: data)
                        DataService.instance.saveTableData(rawData: decoded[0])
                    }
                    
                    DispatchQueue.main.async {
                        self.reloadTable()
                        self.ratesDateLbl.text = DataService.instance.currencyDate
                    }
                    
                } catch {
                    if let dataResponse = String.init(data: data, encoding: .utf8) {
                        ShowError.alert(title: "Brak danych", message: "Dla podanych parametrów brak dostępnych kursów walut. Odpowiedź z serwera:\n\(dataResponse)", self)
                    } else {
                        ShowError.alert(title: "Błąd", message: "Wystąpił bliżej nieokreślony błąd. Proszę spróbować jeszcze raz dla innych parametrów.", self)
                    }
                }
                
            }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
        }
        
    }
    
    
    private func refreshData() {
        activityIndicator.startAnimating()
        
        if DataService.instance.ratesCount(for: currentTable) > 0 {
            reloadTable()
        } else {
            downloadData()
        }
    }
    
    
    
}




extension MainVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
            
            vc.currency = DataService.instance.getOneCurrency(for: currentTable, at: indexPath.row)
            vc.currentTable = currentTable
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

