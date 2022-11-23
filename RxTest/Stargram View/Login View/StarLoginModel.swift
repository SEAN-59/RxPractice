//
//  StarLoginModel.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/20.
//

import RxSwift

class StarLoginModel {
//    static let starLoginModel = StarLoginModel()
    private var userData = UserData(uid: "", email: "")
    
    func saveUserData(_ uid: String?, _ email: String?) {
        print(uid)
        print(email)
        if let uid = uid, let email = email {
            self.userData.uid = uid
            self.userData.email = email
        }
    }
    
    func readData() {
        print(self.userData)
    }
    
    
    
}
