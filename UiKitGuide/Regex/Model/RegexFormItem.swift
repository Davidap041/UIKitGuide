//
//  RegexFormItem.swift
//  UiKitGuide
//
//  Created by Davi Paiva on 27/12/24.
//

import Foundation
// Regex Form Item
struct RegexFormItem {
    let pattern: String
    let error : ValidationError
}

// Validation Protocol
protocol ValidationManager{
    func validate(_ val: Any) throws
}

// Regex Validator Manager
struct RegexValidationManager: ValidationManager {
    private let items: [RegexFormItem]
    
    init(_ items: [RegexFormItem]){
        self.items = items
    }
    
    func validate(_ val: Any) throws {
        let val = (val as? String) ?? ""
        
        try items.forEach { regexItem in
            let regex = try? NSRegularExpression(pattern: regexItem.pattern)
            let range = NSRange(location: 0, length: val.count)
            if regex?.firstMatch(in: val,options: [], range: range) == nil {
                throw regexItem.error
            }
        }
    }
}


// Date Validator Manager
struct DateValidationManager: ValidationManager {
    private let ageLimit: Int = 18
    
    func validate(_ val: Any) throws {
        
        guard let date = val as? Date else {
            throw ValidationError.custom(message: "Invalid Value passed")
        }
        
        if let calculateYr = Calendar.current.dateComponents([.year], from: date, to:Date()).year,
           calculateYr < ageLimit {
            throw ValidationError.custom(message: "Age should be greater than \(ageLimit)")
        }
    }
}
