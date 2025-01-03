//
//  RegexPatterns.swift
//  UiKitGuide
//
//  Created by Davi Paiva on 27/12/24.
//

enum RegexPatterns{
    static let emailChars = ".*[@].*"
    static let higherThanSixChars = "^.{6,}$"
    static let name = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
}
