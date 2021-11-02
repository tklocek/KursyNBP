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

        // Do any additional setup after loading the view.
        
        currencyNameLbl.text = currency.currency
        currencyCodeLbl.text = currency.code
        
        setupView()
        
    }
    
    
    func setupView() {
        calendarTo.maximumDate = Date()
        calendarFrom.maximumDate = Date()
        activityIndicator.stopAnimating()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reloadBtnPressed(_ sender: Any) {
        activityIndicator.startAnimating()
    
    }
    
    
    @IBAction func fromDateEdited(_ sender: Any) {
        
         do {
             try validateDateSetup()
         }
        catch DateError.fromMoreThanTo {
            errorMessage(title: "Źle wybrane daty", message: "Data początkowa musi być mniejsza lub równa dacie końcowej. Zmień daty aby kontynuować.")
            
         }
        catch DateError.tooManyDaysBetween {
            errorMessage(title: "Za duża odległość pomiędzy dniami", message: "Bank NBP wymaga aby maksymalny odstęp między datami nie był większy niż 90 dni. \nProszę wybrać inne daty.")
        } catch {
            errorMessage(title: "Błąd", message: "Wystąpił nieokreślony błąd")
        }
        
    }
    
  
    
    
    private func validateDateSetup() throws {
        let fromDate = calendarFrom.date
        
        let toDate = calendarTo.date
        
        print(fromDate)
        print(toDate)
        
        
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


    private func errorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController (title: title , message: message , preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            
            self.present(alert, animated: true)
        }
        
    }
    

    
    
    

}

extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewCell", for: indexPath) as? DetailViewCell {
//            guard let cellData = DataService.instance.getOneCurrency(for: currentTable, at: indexPath.item) else
//            {
//                return MainViewCell()
//
//            }
//
//            cell.updateView(currency: cellData)
//
            return cell
        }
        
        
        return DetailViewCell()
        
        
        
        
    }
    
    
    
    
}

