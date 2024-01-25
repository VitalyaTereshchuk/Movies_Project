//
//  CapitalLetter.swift
//  Movies
//
//  Created by Vitaly on 07.01.2024.
//

import Foundation

extension String {
    func capitalLetter() ->  String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
