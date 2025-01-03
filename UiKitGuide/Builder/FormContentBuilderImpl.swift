//
//  FormContentBuilderImpl.swift
//  UiKitGuide
//
//  Created by Davi on 17/12/24.
//

import Foundation
import Combine

final class FormContentBuilderImpl {
    private(set) var user = PassthroughSubject<[String:Any], Never>()
    
    //MARK: -  Content Form Items
    private(set) var formContent = [
        FormSectionComponent(items: [
            // MARK:  First Name
            TextFormComponent(id: .firstName,
                              placeholder: "First Name",
                              validations: [RegexValidationManager(
                                [RegexFormItem(
                                    pattern: RegexPatterns.name,
                                    error: .custom(message: "Invalid Name entered"))])]),
            // MARK:  Last Name
            TextFormComponent(id: .lastName,
                              placeholder: "Last Name",
                              validations: [RegexValidationManager(
                                [RegexFormItem(
                                    pattern: RegexPatterns.name,
                                    error: .custom(message: "Invalid Name entered"))])]),
            // MARK:  EMAIL
            TextFormComponent(id: .email,
                              placeholder: "Email",
                              keyboardType: .emailAddress,
                              validations: [RegexValidationManager(
                                [RegexFormItem(
                                    pattern: RegexPatterns.emailChars,
                                    error: .custom(message: "Invalid Email entered")),
                                 RegexFormItem(
                                    pattern: RegexPatterns.higherThanSixChars,
                                    error: .custom(message: "Less than 6 characters"))])]),
            // MARK:  DATE
            DateFormComponent(id: .dob,
                              mode: .date,
                              validations: [DateValidationManager()]),
            // MARK:   Button
            ButtonFormItem(id: .submit,
                           title: "Confirm")
        ])
    ]
    
    // MARK: - Methods
    func update (val:Any, at indexPath: IndexPath) {
        formContent[indexPath.section].items[indexPath.row].value = val
    }
    
    func validate () -> Void {
        do {
            let  formComponents = formContent
                .flatMap{$0.items}
                .filter{$0.formID != .submit}
            
            for component in formComponents {
                for validator in component.validations {
                    try validator.validate(component.value as Any)
                }
            }
            let validValues = formComponents.map{($0.formID.rawValue, $0.value)}
            let validDict = Dictionary(uniqueKeysWithValues: validValues) as [String: Any]
            
            // Passthrough here
            user.send(validDict)
            
        }
        catch{
            print("Something went wrong: \(error)")
        }
    }
    
}

