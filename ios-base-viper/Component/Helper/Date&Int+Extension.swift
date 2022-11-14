//
//  String+Extension.swift
//  ios-base-viper
//
//  Created by Isaac on 11/6/22.
//

import Foundation

extension Date {
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func formattedDateString(format: String? = "h:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_AU")
        dateFormatter.timeZone = TimeZone(abbreviation: "Australia/Sydney")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format

        return dateFormatter.string(from: self)
    }
}

extension Int{
    func thousandSeparatorFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        let myDouble = self
        let finalText = formatter.string(for: myDouble) ?? "-"
        
        return finalText
    }
}

extension Double {
    func percentageFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        var finalText = formatter.string(for: self) ?? "-"
        
        if self > 0 {
            finalText = "+\(finalText)%"
        } else {
            finalText = "\(finalText)%"
        }
        
        return finalText
    }
}
