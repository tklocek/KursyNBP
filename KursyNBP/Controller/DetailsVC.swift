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
    private var doneGettingData: Bool = true {
        didSet {
            DispatchQueue.main.async {
                switch self.doneGettingData {
                case true: self.activityIndicator.stopAnimating()
                case false: self.activityIndicator.startAnimating()
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        setupView()
        
    }
    
    
    func setupView() {
        self.doneGettingData = false
        currencyNameLbl.text = currency.currency
        currencyCodeLbl.text = currency.code
        
        calendarTo.maximumDate = Date()
        calendarFrom.date = Calendar.current.date(byAdding: .day, value: -30, to: Date() ) ?? Date()
        calendarFrom.maximumDate = Date()
        
        downloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        clearAll()
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        clearAll()
    }
    
    @IBAction func reloadBtnPressed(_ sender: Any) {
        self.doneGettingData = false
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
           ShowError.alert(title: "??le wybrane daty", message: "Data pocz??tkowa musi by?? mniejsza lub r??wna dacie ko??cowej. Zmie?? daty aby kontynuowa??.", self)
        }
       catch DateError.tooManyDaysBetween {
           ShowError.alert(title: "Za du??a odleg??o???? pomi??dzy dniami", message: "Bank NBP wymaga aby maksymalny odst??p mi??dzy datami nie by?? wi??kszy ni?? 90 dni. \nProsz?? wybra?? inne daty.", self)
       } catch {
           ShowError.alert(title: "B????d", message: "Wyst??pi?? nieokre??lony b????d", self)
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
                ShowError.alert(title: "Niezdefiniowany b????d sieciowy", message: error.localizedDescription, self)
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
                        ShowError.alert(title: "Brak danych", message: "Dla podanych parametr??w brak dost??pnych kurs??w walut. Odpowied?? z serwera:\n\(dataResponse)", self)
                    } else {
                        ShowError.alert(title: "B????d", message: "Wyst??pi?? bli??ej nieokre??lony b????d. Prosz?? spr??bowa?? jeszcze raz dla innych parametr??w.", self)
                    }
                }
            }
            
            self.doneGettingData = true
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

