//
//  StarLoginUtilities.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/20.
//

import Foundation

enum AlertCheck {
    case yes
    case no
    case cancel
}

enum CreateError : String {
    case wrongEmailFormat = "The email address is badly formatted."
    case needMorePassword = "The password must be 6 characters long or more."
}

struct UserData{
    var uid: String
    var email: String
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}

