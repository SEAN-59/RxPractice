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
    
    private lazy var choiceCalculatorBtn: UIButton = {
        let button = UIButton()
        button.setTitle("계산기", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
//        button.addTarget(self, action: #selector(T), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10.0
        bind()
        attribute()
        layout()
    }
}

private extension MainViewController {
    private func bind() {
//        self.rx.testButton
        choiceCalculatorBtn.rx.tap
            .bind{
                print("Clicked Calculator")
                self.openCalculator()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        view.addSubview(self.contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaInsets).inset(48.0)
        }
        
        [titleLabel, choiceCalculatorBtn].forEach{contentView.addSubview($0)}

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.0)
            $0.centerX.equalToSuperview()
        }
        
        choiceCalculatorBtn.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()

        }
    }
}

private extension MainViewController {
    private func openCalculator() {
        self.dismiss(animated: true)
        let nextVC = CalculatorViewController()
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC,animated: true)
    }
}
