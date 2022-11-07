//
//  CalculatorViewController.swift
//  RxTest
//
//  Created by Sean Kim on 2022/10/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CalculatorViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var firstTextStack: String = "0"
    private var secondTextStack: String = "0"
    private var firstClickDot: Bool = false
    private var secondClickDot: Bool = false
    private var clickDotCheck: Bool = false
    
    private var clickedSign: String = "none"
    
    private lazy var contentsView = UIView()
    
    private lazy var inputLabel: paddingLabel = {
        let label = paddingLabel(padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 10))
        label.font = .systemFont(ofSize: 50.0, weight: .bold)
        label.textColor = .label
        label.textAlignment = .right
        label.text = "0"
        
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.label.cgColor
        label.layer.cornerRadius = 10.0
        
        return label
    }()
    
    private lazy var dotBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle(".", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var doubleZeroBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("00", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var zeroBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("0", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var equalBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("=", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var plusBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    
    private lazy var firstLineStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        
        [
            dotBtn,doubleZeroBtn,zeroBtn,equalBtn,plusBtn
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var allClearBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("AC", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var oneBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("1", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var twoBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("2", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var threeBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("3", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var minusBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("-", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    
    private lazy var secondLineStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        
        [
            allClearBtn,oneBtn,twoBtn,threeBtn,minusBtn
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var clearBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("C", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var fourBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("4", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var fiveBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("5", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var sixBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("6", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var multiBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("X", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    
    private lazy var thirdLineStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        
        [
            clearBtn,fourBtn,fiveBtn,sixBtn,multiBtn
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var changeSignBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("+/-", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var sevenBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("7", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var eightBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("8", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var nineBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("9", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    private lazy var divisionBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("÷", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 35.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    
    private lazy var fourthLineStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        
        [
            changeSignBtn,sevenBtn,eightBtn,nineBtn,divisionBtn
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var backBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("돌아가기", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bind()
        attribute()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layout()
    }
}

private extension CalculatorViewController {
    private func bind() {
        dotBtn.rx.tap.subscribe(onNext: {
            self.buttonClick(".")
        }).disposed(by: disposeBag)
        doubleZeroBtn.rx.tap.subscribe(onNext: {
            self.buttonClick("00")
        }).disposed(by: disposeBag)
        zeroBtn.rx.tap.subscribe(onNext: {
            self.buttonClick("0")
        }).disposed(by: disposeBag)
        
        oneBtn.rx.tap.subscribe(onNext: {
            self.buttonClick("1")
        }).disposed(by: disposeBag)
        twoBtn.rx.tap.subscribe(onNext: {
            self.buttonClick("2")
        }).disposed(by: disposeBag)
        threeBtn.rx.tap.subscribe(onNext: {
            self.buttonClick("3")
        }).disposed(by: disposeBag)
        
        fourBtn.rx.tap.subscribe(onNext: {
            self.buttonClick("4")
        }).disposed(by: disposeBag)
        fiveBtn.rx.tap.subscribe(onNext: {
            self.buttonClick("5")
        }).disposed(by: disposeBag)
        sixBtn.rx.tap.subscribe(onNext: {
            self.buttonClick("6")
        }).disposed(by: disposeBag)
        
        sevenBtn.rx.tap.subscribe(onNext: {
            self.buttonClick("7")
        }).disposed(by: disposeBag)
        eightBtn.rx.tap.subscribe(onNext: {
            self.buttonClick("8")
        }).disposed(by: disposeBag)
        nineBtn.rx.tap.subscribe(onNext: {
            self.buttonClick("9")
        }).disposed(by: disposeBag)
        
        plusBtn.rx.tap.subscribe(onNext: {
            self.clickedSignAction(self.plusBtn)
        }).disposed(by: disposeBag)
        minusBtn.rx.tap.subscribe(onNext: {
            self.clickedSignAction(self.minusBtn)
        }).disposed(by: disposeBag)
        multiBtn.rx.tap.subscribe(onNext: {
            self.clickedSignAction(self.multiBtn)
        }).disposed(by: disposeBag)
        divisionBtn.rx.tap.subscribe(onNext: {
            self.clickedSignAction(self.divisionBtn)
        }).disposed(by: disposeBag)
        
        equalBtn.rx.tap.subscribe(onNext: {
            self.endCalculator()
        }).disposed(by: disposeBag)
        
        allClearBtn.rx.tap.subscribe(onNext: {
            self.allClear()
        }).disposed(by: disposeBag)
        
        clearBtn.rx.tap.subscribe(onNext: {
            self.clearCurrentString()
        }).disposed(by: disposeBag)
        
        changeSignBtn.rx.tap.subscribe(onNext: {
            self.changeSign()
        }).disposed(by: disposeBag)
        
        backBtn.rx.tap.subscribe(onNext: {
//            self.returnMenu()
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        view.addSubview(contentsView)
        [
            inputLabel,
            firstLineStackView,
            secondLineStackView,
            thirdLineStackView,
            fourthLineStackView,
            backBtn
        ].forEach{contentsView.addSubview($0)}
        
        contentsView.layer.cornerRadius = 10.0
        contentsView.layer.borderWidth = 1
        
        contentsView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaInsets).inset(48.0)
            $0.bottom.equalTo(view.safeAreaInsets).inset(24.0)
            $0.leading.trailing.equalTo(view.safeAreaInsets)
        }
        
        inputLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8.0)
            $0.height.equalTo(100)
        }
        
        fourthLineStackView.snp.makeConstraints {
            $0.top.equalTo(inputLabel.snp.bottom).offset(24.0)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8.0)
        }
        
        thirdLineStackView.snp.makeConstraints {
            $0.top.equalTo(fourthLineStackView.snp.bottom).offset(8.0)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8.0)
        }
        
        secondLineStackView.snp.makeConstraints {
            $0.top.equalTo(thirdLineStackView.snp.bottom).offset(8.0)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8.0)
        }
        
        firstLineStackView.snp.makeConstraints {
            $0.top.equalTo(secondLineStackView.snp.bottom).offset(8.0)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8.0)
        }
        
        backBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
    }
}

private extension CalculatorViewController {
    
    private func returnMenu() {
        self.dismiss(animated: true)
    }
    
    private func changeSign() {
        if clickedSign != "none" {
            self.secondTextStack = "\(Double(secondTextStack)! * -1)"
            self.inputLabel.text = self.secondTextStack
        } else {
            self.firstTextStack = "\(Double(firstTextStack)! * -1)"
            self.inputLabel.text = self.firstTextStack
        }
    }
    
    private func clearCurrentString() {
        if clickedSign != "none" {
            self.secondTextStack = "0"
            self.secondClickDot = false
            self.clickDotCheck = false
        } else {
            self.firstTextStack = "0"
            self.firstClickDot = false
        }
        
        self.inputLabel.text = "0"
    }
    
    private func allClear() {
        self.inputLabel.text = "0"
        self.firstTextStack = "0"
        self.secondTextStack = "0"
        self.firstClickDot = false
        self.secondClickDot = false
        self.clickDotCheck = false
        switch clickedSign {
        case "+":
            changedColor(plusBtn)
        case "-":
            changedColor(minusBtn)
        case "X":
            changedColor(multiBtn)
        case "÷":
            changedColor(divisionBtn)
        default:
            print("default")
        }
        self.clickedSign = "none"
        
    }
    
    private func endCalculator() {
        let firstText = self.firstTextStack
        let secondText = self.secondTextStack
        var save = 0.0
        switch clickedSign {
        case "+":
            save = Double(firstText)! + Double(secondText)!
        case "-":
            save = Double(firstText)! - Double(secondText)!
        case "X":
            save = Double(firstText)! * Double(secondText)!
        case "÷":
            save = Double(firstText)! / Double(secondText)!
        default:
            save = Double(firstText)!
        }
        
        
        switch clickedSign {
        case "+":
            changedColor(plusBtn)
        case "-":
            changedColor(minusBtn)
        case "X":
            changedColor(multiBtn)
        case "÷":
            changedColor(divisionBtn)
        default:
            print("default")
        }
        
        if save-Double(Int(save)) != 0 {
            print("is Double")
        }
        
        if save != 0 {
            self.firstTextStack = "\(save)"
        } else {
            self.firstTextStack = "0"
        }
        
        self.clickedSign = "none"
        self.secondTextStack = "0"
        self.inputLabel.text = "\(self.firstTextStack)"
        self.secondClickDot = false
        self.clickDotCheck = false
        
    }
    
    private func clickedSignAction(_ button: UIButton) {
        let firstText = self.firstTextStack
        let secondText = self.secondTextStack
        var save = 0.0
        
        if clickedSign != "none" { // 눌러져 있는 상황
            switch clickedSign {
            case "+":
                save = Double(firstText)! + Double(secondText)!
            case "-":
                save = Double(firstText)! - Double(secondText)!
            case "X":
                save = Double(firstText)! * Double(secondText)!
            case "÷":
                save = Double(firstText)! / Double(secondText)!
            default:
                print("default")
            }
            if save.isInfinite || save.isNaN {
                save = 0
            }
            
            if button.titleLabel!.text! != clickedSign { // 만약에 전에 누른 사인 키와 다른 키일 경우에 해당 키 불 들어오게 하고 전에꺼 끄기
                switch clickedSign {
                case "+":
                    changedColor(plusBtn)
                case "-":
                    changedColor(minusBtn)
                case "X":
                    changedColor(multiBtn)
                case "÷":
                    changedColor(divisionBtn)
                default:
                    print("default")
                }
                switch button.titleLabel!.text! {
                case "+":
                    changedColor(plusBtn)
                case "-":
                    changedColor(minusBtn)
                case "X":
                    changedColor(multiBtn)
                case "÷":
                    changedColor(divisionBtn)
                default:
                    print("default")
                }
            }
            
            if save != 0.0 {
                self.firstTextStack = "\(save)"
            } else {
                self.firstTextStack = "0"
            }
            
            self.secondTextStack = "0"
            self.inputLabel.text = self.firstTextStack
            self.secondClickDot = false
            self.clickDotCheck = false
            
        } else { // 누르기 전의 상황
            changedColor(button)
        }
        
        self.clickedSign = "\(button.titleLabel!.text!)"
    }
    
    private func changedColor(_ button: UIButton) {
        if button.layer.borderColor == UIColor.label.cgColor {
            button.layer.borderColor = UIColor.blue.cgColor
            button.setTitleColor(UIColor.blue, for: .normal)
            button.backgroundColor = .init(cgColor: CGColor(red: 0, green: 0, blue: 1, alpha: 0.2))
        } else {
            button.layer.borderColor = UIColor.label.cgColor
            button.setTitleColor(UIColor.label, for: .normal)
            button.backgroundColor = .systemBackground
        }
    }
    
    private func buttonClick(_ button: String){
        var textStack = firstTextStack
        if self.clickedSign != "none" {
            textStack = secondTextStack
            self.clickDotCheck = true
        } else {
            self.clickDotCheck = false
        }
        
        if textStack.count < 10 {
            if button == "." && !self.firstClickDot && !self.clickDotCheck { // Dot 버튼을 누른건데 아직 Dot은 기록되지 않았다. = 누르면서 첫번째 스트링에 들어가게 됨
                textStack.append(button)
                self.firstClickDot = true
            } else if button == "." && !self.secondClickDot && self.clickDotCheck{
                textStack.append(button)
                self.secondClickDot = true
            } else if button != "." { // Dot 을 누르지 않은 경우 = 일반 숫자를 누른것
                if textStack == "0" { // 0 일 경우에는 0이던 00이던 다 0이니까 안됨
                    if button != "0" && button != "00"{
                        textStack = button
                    }
                } else { // 0 이 아닌경우
                    textStack.append(button)
                }
            }
        }
        
        self.inputLabel.text = textStack
        
        if self.clickedSign != "none" {
            self.secondTextStack = textStack
        } else {
            self.firstTextStack = textStack
        }
        
    }
}

class paddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
