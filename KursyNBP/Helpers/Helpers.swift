//
//  Helpers.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-10-29.
//

import Foundation


func dateToStr(date: Date, format: String) -> String {
    //The most popular format: "yyyy-MM-dd hh:mm:ss"

    let df = DateFormatter()
    df.dateFormat = format
    return df.string(from: date)
}
