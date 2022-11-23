//
//  StarLoginViewController.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/20.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
//import rx
import Firebase
import FirebaseCore
import FirebaseAuth


final class StarLoginViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = StarLoginViewModel()
    
    // MARK: Components
    
    private lazy var idTxf: UITextField = {
        let textField = UITextField()
        
        textField.font = .systemFont(ofSize: 20.0, weight: .regular)
        textField.placeholder = "이메일"
        textField.textAlignment = .left
        textField.backgroundColor = .systemBackground
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.tintColor = .clear
        textField.addPadding(.left, 10)
        
        return textField
    }()
    
    private lazy var passwordTxf: UITextField = {
        let textField = UITextField()
        
        textField.font = .systemFont(ofSize: 20.0, weight: .regular)
        textField.placeholder = "패스워드"
        textField.textAlignment = .left
        textField.backgroundColor = .systemBackground
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.tintColor = .clear
        textField.addPadding(.left, 10)
        
        return textField
    }()
    
    private lazy var txfStack: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
        
        [
            idTxf,
            passwordTxf
        ].forEach { stackView.addArrangedSubview($0) }
        idTxf.snp.makeConstraints{
            $0.height.equalTo(35)
        }
        passwordTxf.snp.makeConstraints{
            $0.height.equalTo(35)
        }
        
        return stackView
    }()
    
    private lazy var googleLoginBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        
        button.setTitle("Google로 로그인", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    
    private lazy var emailLoginBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        
        button.setTitle("이메일로 로그인", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.isSizeUpBtn = true
        
        return button
    }()
    
    private lazy var signInbtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.isSizeUpBtn = true
        
        return button
    }()
    
    private lazy var signOutbtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.isSizeUpBtn = true
        
        return button
    }()
    
    private lazy var btnStack: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 10.0
        
        [
            googleLoginBtn,
            emailLoginBtn,
            signInbtn,
            signOutbtn
        ].forEach { stackView.addArrangedSubview($0) }
        
        
        
        return stackView
    }()
    
    private lazy var stackStack: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
        
        [
            txfStack,
            btnStack
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    // MARK: - View CALL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.attribute()
        self.layout()
    }
    
    
    
}

private extension StarLoginViewController {
    private func bind() {
        
        googleLoginBtn.rx.tap
            .bind{
//                self.googleLogin()
            }.disposed(by: disposeBag)
        
        emailLoginBtn.rx.tap
            .withUnretained(self)
            .bind{ owner, event in
                owner.txfStack.isHidden.toggle()
                owner.emailLoginBtn.isHidden.toggle()
                owner.signInbtn.isHidden.toggle()
            }.disposed(by: disposeBag)
        
        signInbtn.rx.tap
            .withUnretained(self)
            .bind{ owner, event in
                owner.viewModel.tapSignIn(owner.idTxf.text, owner.passwordTxf.text)
                    .subscribe(
                        onNext: { auth in
                            owner.viewModel.saveData(auth)
                        },
                        onError: { error in
                            owner.showAlert("로그인 오류",
                                            "로그인에 실패하였습니다.\n다시 시도해주세요.",
                                            ["다시 시도","계정 만들기"],
                                            [0,2])
                            .bind(onNext: { status in
                                switch status{
                                case .no:
                                    owner.viewModel.createUser(owner.idTxf.text,
                                                               owner.passwordTxf.text)
                                    .subscribe(
                                        onNext: { _ in
                                            
                                        },
                                        onError: { error in
                                            switch error.localizedDescription {
                                            case "The email address is badly formatted.":
                                                print("case1")
                                                
                                            case "The password must be 6 characters long or more.":
                                                print("case2")
                                                
                                            default :
                                                print(error.localizedDescription)
                                            }
                                        })
                                default:
                                    break
                                }
                            })
                        }
                    )
            }.disposed(by: disposeBag)
        
        signOutbtn.rx.tap
            .withUnretained(self)
            .bind{ owner, event in
                owner.viewModel.checkData()
            }.disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "로그인"
        self.txfStack.isHidden = true
        self.signInbtn.isHidden = true
    }
    
    private func layout() {
        [
            stackStack
        ].forEach{view.addSubview($0)}
        
        
        stackStack.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8.0)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
    }
}
private extension StarLoginViewController {
    
        private func googleLogin(){
    
        }
    
    /// Alert + Rx
    ///
    /// 최대 3개의 값을 내보내나 버튼의 액션은 원하는 만큼 추가 가능함
    ///
    /// .onNext 로 타입에 맞게.ok, .cancel, .no 가 방출 됨
    ///
    /// type 은 0, 1, 2 로 구성 = .default, .cancel, .destructive

    private func showAlert(_ alertTitle: String,
                           _ alertMessage: String,
                           _ titleArray: [String],
                           _ typeArray: [Int]
    ) -> Observable<AlertCheck> {
        return Observable.create { Observer in
            let showAlertController = UIAlertController(title: alertTitle,
                                                        message: alertMessage,
                                                        preferredStyle: .alert)
            
            for i in 0 ..< typeArray.count {
                let action = UIAlertAction(title: titleArray[i],
                                           style: {
                    switch typeArray[i]{
                    case 0:
                        return .default
                    case 1:
                        return .cancel
                    case 2:
                        return .destructive
                    default:
                        fatalError("Wrong Alert Type")
                    }
                }()) { _ in
                    switch typeArray[i]{
                    case 0:
                        Observer.onNext(.yes)
                        Observer.onCompleted()
                    case 1:
                        Observer.onNext(.cancel)
                        Observer.onCompleted()
                    case 2:
                        Observer.onNext(.no)
                        Observer.onCompleted()
                    default:
                        Observer.onError( fatalError("Wrong Alert Type"))
                    }
                }
                
                showAlertController.addAction(action)
            }
            
            self.present(showAlertController, animated: true)
            
            return Disposables.create {
                showAlertController.dismiss(animated: true)
            }
        }
    }
}

extension StarLoginViewController {
    
}


// MARK: -


//            let yesAction = UIAlertAction(title: yesTitle, style: .default) { _ in
//                Observer.onNext(.yes)
//                Observer.onCompleted()
//            }
//            let noAction = UIAlertAction(title: noTitle, style: .destructive){ _ in
//                Observer.onNext(.no)
//                Observer.onCompleted()
//            }

//            [
//                yesAction,
//                noAction
//            ].forEach{showAlertController.addAction($0)}
