//
//  StarLoginViewModel.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/20.
//

import UIKit
import RxSwift

import Firebase
import FirebaseCore
import FirebaseAuth

class StarLoginViewModel {
    private let disposeBag = DisposeBag()
//    private let model = StarLoginModel.starLoginModel
    private let model = StarLoginModel()
    
    private let errSubject = PublishSubject<Error>()
    
    private var testAdmin: [String] {
        get {
            guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
                fatalError("Couldn't find File")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let valueArray = plist?.object(forKey: "AuthEmail") as? [String] else {
                fatalError("Couldn't find key")
            }
            return valueArray
        }
    }
    
    func tapSignIn(_ id: String?, _ password: String?) -> Observable<AuthDataResult> {
        guard let id = id, let password = password else { return Observable.of()}
        
        let resultCheck = Observable<AuthDataResult>.create{ Observer in
            Auth.auth().signIn(withEmail: id, password: password)
            { auth, error in
                if let error = error {
                    Observer.onError(error)
                } else if let auth = auth{
                    Observer.onNext(auth)
                    Observer.onCompleted()
                }
            }
            return Disposables.create()
        }
        
        return resultCheck
    }
    
    func createUser2(_ id: String?, _ password: String?) {
        // 비밀번호 6글자 미만이면 경고 뜸
        guard let id = id, let password = password else { return }
        Auth.auth().createUser(
            withEmail: id,
            password: password) { auth, error in
                if let auth = auth {
                    self.model.saveUserData(auth.user.uid, auth.user.email)
                }
            }
    }
    
    func createUser(_ id: String?, _ password: String?) -> Observable<AuthDataResult>{
        guard let id = id, let password = password else { return Observable.of()}
        
        let resultCheck = Observable<AuthDataResult>.create{ Observer in
            Auth.auth().createUser(
                withEmail: id,
                password: password) { auth, error in
                    if let error = error {
                        Observer.onError(error)
                    } else if let auth = auth{
                        Observer.onNext(auth)
                        Observer.onCompleted()
                    }
                    
                }
            return Disposables.create()
        }
        
        return resultCheck
        
    }
    
    func checkData() {
        self.model.readData()
    }
    
    func saveData(_ auth: AuthDataResult) {
        self.model.saveUserData(auth.user.uid, auth.user.email)
    }
    
}

private extension StarLoginViewModel{
    
}
