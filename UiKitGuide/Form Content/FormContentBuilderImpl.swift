//
//  FormContentBuilderImpl.swift
//  UiKitGuide
//
//  Created by Davi on 17/12/24.
//

import Foundation

final class FormContentBuilderImpl {
    var content: [FormSectionComponent] {
        
        return [
            
            FormSectionComponent(items: [
                TextFormComponent(placeholder: "First Name"),
                TextFormComponent(placeholder: "Last Name"),
                TextFormComponent(placeholder: "Email", keyboardType: .emailAddress),
                DateFormComponent(mode: .date),
                ButtonFormComponent(title: "Confirm")
            ])
        ]
    }
}
