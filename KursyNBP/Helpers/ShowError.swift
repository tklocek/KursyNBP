//
//  ShowError.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-11-03.
//

import UIKit


class ShowError{
    
    static func alert(title: String, message: String, _ vc: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController (title: title , message: message , preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            
            vc.present(alert, animated: true)
        }
        
    }
}
