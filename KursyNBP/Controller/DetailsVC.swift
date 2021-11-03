//
//  DetailsVC.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-10-29.
//

import UIKit


enum DateError: Error {
    case fromMoreThanTo
    case tooManyDaysBetween
}


class DetailsVC: UIViewController {

    //VARs
    var currency: Currency!
    var currentTable: CurrencyTable!
    
    
    @IBOutlet weak var currencyNameLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var currencyCodeLbl: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var calendarFrom: UIDatePicker!
    @IBOutlet weak var calendarTo: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        setupView()
        
    }
    
    
    func setupView() {
        currencyNameLbl.text = currency.currency
        currencyCodeLbl.text = currency.code
        
        calendarTo.maximumDate = Date()
        calendarFrom.date = Calendar.current.date(byAdding: .day, value: -30, to: Date() ) ?? Date()
        calendarFrom.maximumDate = Date()
        
        downloadData()
        activityIndicator.stopAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        clearAll()
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        clearAll()
    }
    
    @IBAction func reloadBtnPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        DataService.instance.clearHistData()
        reloadTable()
        downloadData()
    }
    
    @IBAction func fromDateEdited(_ sender: Any) {
        checkValidationOfDates()
    }
    
    @IBAction func toDateEdited(_ sender: Any) {
        checkValidationOfDates()
    }
    
    private func clearAll() {
        DataService.instance.clearHistData()
        dismiss(animated: true, completion: nil)
    }
    
    private func checkValidationOfDates() {
        reloadBtn.isEnabled = false
        do {
            try validateDateSetup()
            reloadBtn.isEnabled = true
            downloadData()
        }
       catch DateError.fromMoreThanTo {
           ShowError.alert(title: "Źle wybrane daty", message: "Data początkowa musi być mniejsza lub równa dacie końcowej. Zmień daty aby kontynuować.", self)
        }
       catch DateError.tooManyDaysBetween {
           ShowError.alert(title: "Za duża odległość pomiędzy dniami", message: "Bank NBP wymaga aby maksymalny odstęp między datami nie był większy niż 90 dni. \nProszę wybrać inne daty.", self)
       } catch {
           ShowError.alert(title: "Błąd", message: "Wystąpił nieokreślony błąd", self)
       }
        
    }
    
    
    private func validateDateSetup() throws {
        let fromDate = calendarFrom.date
        let toDate = calendarTo.date

        if fromDate > toDate {
            throw DateError.fromMoreThanTo
        }
        if numberOfDaysBetween(fromDate, and: toDate) > 90 {
            throw DateError.tooManyDaysBetween
        }
    }
    
    private func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = Calendar.current.startOfDay(for: from)
        let toDate = Calendar.current.startOfDay(for: to)
        let days = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        
        if let count = days.value(for: .day) {
            return count + 1
        }
        
        return 0
    }

    
    private func downloadData() {
        activityIndicator.startAnimating()
        
        let fromDate = dateToStr(date: calendarFrom.date, format: "yyyy-MM-dd")
        let toDate = dateToStr(date: calendarTo.date, format: "yyyy-MM-dd")
        
        Networking.fetchHistory(for: currency.code, in: currentTable, from: fromDate, to: toDate) { result in
            switch result {
            case .failure(let error):
                ShowError.alert(title: "Niezdefiniowany błąd sieciowy", message: error.localizedDescription, self)
            case .success(let data):
                do {
                    if self.currentTable != .c {
                        let decoded = try JSONDecoder().decode(ABTableHist.self, from: data)
                        DataService.instance.saveHistData(rawData: decoded)
                    } else {
                        let decoded = try JSONDecoder().decode(CTableHist.self, from: data)
                        DataService.instance.saveHistData(rawData: decoded)
                    }
                    
                    self.reloadTable()
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
    
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    

}

extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.historicalDataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentTable == .c {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCViewCell", for: indexPath) as? DetailCViewCell {
                guard let cellData = DataService.instance.getOneHistData(at: indexPath.item) else
                {
                    return DetailCViewCell()
                }
    
                cell.updateView(histData: cellData)
                return cell
            }
            
            return DetailCViewCell()
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailABViewCell", for: indexPath) as? DetailABViewCell {
                guard let cellData = DataService.instance.getOneHistData(at: indexPath.item) else
                {
                    return DetailABViewCell()
                }
                
                cell.updateView(histData: cellData)
                return cell
            }
            
            return DetailABViewCell()
        }
    }
    
    
    
    
}

