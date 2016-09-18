//
//  String+Capitalize.swift
//  WeatherSwift
//
//  Created by Женя Михайлова on 18.09.16.
//  Copyright © 2016 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

extension String {
    
    func firstLetterCapitalizedString() -> String {
        var initialString = self
        initialString.replaceRange(initialString.startIndex...initialString.startIndex, with: String(initialString[initialString.startIndex]).capitalizedString)
        return initialString
    }
}
