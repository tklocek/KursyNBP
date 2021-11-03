//
//  String.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-11-03.
//

import Foundation

extension StringProtocol {
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
