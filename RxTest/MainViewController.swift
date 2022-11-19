//
//  MainViewController.swift
//  RxTest
//
//  Created by Sean Kim on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private lazy var contentView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 30.0, weight: .bold)
        label.textColor = .label
        label.text = "Rx 연습 프로그램"
        
        return label
    }()
    
    private lazy var choiceBtnStackview: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        
        [
            choiceCalculatorBtn,
            choiceDDayBtn,
            choiceSelectAreaBtn
            
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var choiceCalculatorBtn: UIButton = {
        let button = UIButton()
        button.setTitle("계산기", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        return button
    }()
    
    private lazy var choiceDDayBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("D-DAY 계산기", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        
        return button
    }()
    
    private lazy var choiceSelectAreaBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        
        button.isSizeUpBtn = true
        
        button.setTitle("랜덤여행", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        attribute()
        layout()
    }
}

private extension MainViewController {
    private func bind() {
        
        choiceCalculatorBtn.rx.tap.bind{
            self.openCalculator()
        }.disposed(by: disposeBag)
        
        choiceDDayBtn.rx.tap.bind {
            self.openD_Day()
        }.disposed(by: disposeBag)
        
        choiceSelectAreaBtn.rx.tap.bind {
            self.openSelectArea()
        }.disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        view.addSubview(self.contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaInsets).inset(48.0)
        }
        
        [
            titleLabel,
            choiceBtnStackview
        ].forEach{contentView.addSubview($0)}

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.0)
            $0.centerX.equalToSuperview()
        }
        
        choiceBtnStackview.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            $0.centerX.equalToSuperview()
            $0.bottom.leading.trailing.equalToSuperview()
            
        }
        
    }
}

private extension MainViewController {
    private func openCalculator() {
        let nextVC = CalculatorViewController()
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC,animated: true)
    }
    
    private func openD_Day() {
        let nextVC = UINavigationController(rootViewController: D_DayViewController())
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC,animated: true)
    }
    
    private func openSelectArea() {
        let nextVC = UINavigationController(rootViewController: SelectAreaMainViewController())
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC,animated: true)
    }
}
