//
//  FormModel.swift
//  UiKitGuide
//
//  Created by Davi on 17/12/24.
//

import UIKit

protocol FormItem {
    var id: UUID {get}
    var formID: FormField {get}
    var validations: [ValidationManager] {get}
}

protocol FormSectionItem{
    var id: UUID {get}
    var items: [FormComponent] {get}
    init(items: [FormComponent])
}

enum FormField: String,CaseIterable {
    case firstName
    case lastName
    case email
    case dob
    case submit
}

// MARK: - Section Components
final class FormSectionComponent: FormSectionItem, Hashable {
    var id: UUID = UUID()
    var items: [FormComponent]
    
    required init(items: [FormComponent]) {
        self.items = items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FormSectionComponent, rhs: FormSectionComponent) -> Bool{
        lhs.id == rhs.id
    }
}

// MARK: - Form Component
class FormComponent: FormItem, Hashable {
    
    var id: UUID = UUID()
    let formID: FormField
    var value: Any?
    var validations: [ValidationManager]
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FormComponent, rhs: FormComponent) -> Bool {
        lhs.id == rhs.id
    }
    
    init(_ id: FormField, validations: [ValidationManager] = []) {
        self.formID = id
        self.validations = validations
    }
}

// MARK: - Text Component
final class TextFormComponent: FormComponent {
    let placeholder: String
    let keyboardType: UIKeyboardType
    
    init(id:FormField,
         placeholder: String,
         keyboardType: UIKeyboardType = .default,
         validations: [ValidationManager] = []) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        super.init(id, validations: validations)
    }
}

// MARK: - Date Form Component
final class DateFormComponent: FormComponent {
    let mode: UIDatePicker.Mode
    
    init(id:FormField,
         mode: UIDatePicker.Mode,
         validations: [ValidationManager] = []) {
        self.mode = mode
        super.init(id, validations: validations)
    }
}

// MARK: - Button Component
final class ButtonFormItem: FormComponent {
    let title: String
    
    init(id: FormField,
         title: String) {
        self.title = title
        super.init(id)
    }
}

