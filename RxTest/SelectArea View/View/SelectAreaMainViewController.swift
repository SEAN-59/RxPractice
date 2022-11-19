//
//  SelectAreaMainViewController.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/06.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa


//final
class SelectAreaMainViewController: UIViewController {
    
    
    let disposeBag = DisposeBag()
    
    private lazy var contentsView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 50.0, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.text = "랜덤 여행"
        
        return label
    }()
    
    private lazy var btnStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        [
            startBtn,
            listBtn,
            settingBtn,
            ruleBtn
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var startBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        button.isSizeUpBtn = true
        
        button.setTitle("START", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    private lazy var listBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        button.isSizeUpBtn = true
        
        button.setTitle("LIST", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    private lazy var settingBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        button.isSizeUpBtn = true
        
        button.setTitle("SETTING", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    
    private lazy var ruleBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        button.isSizeUpBtn = true
        
        button.setTitle("RULE", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.attribute()
        self.layout()
    }
    
}

private extension SelectAreaMainViewController {
    private func bind() {
        startBtn.rx.tap.bind{
            self.goView("Start")
        }.disposed(by: disposeBag)
        
        listBtn.rx.tap.bind{
            self.goView("List")
        }.disposed(by: disposeBag)
        
        settingBtn.rx.tap.bind{
            self.goView("Setting")
        }.disposed(by: disposeBag)
        
        ruleBtn.rx.tap.bind{
//            self.goView("Rule")
            let day = "2022-01-01"
            let dateFormatter = DateFormatter()
            
            let dateFormatter2 = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter2.dateFormat = "MM"
            let che = Int(dateFormatter2.string(from: dateFormatter.date(from: day)!))!
            print(che)
//            print(dateFormatter)
        }.disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        view.addSubview(contentsView)
        [
            titleLabel,
            btnStackView
        ].forEach{contentsView.addSubview($0)}
        
        contentsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(contentsView.snp.centerY).offset(-48.0)
        }
        btnStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(32.0)
        }
        
    }
}
private extension SelectAreaMainViewController {
    private func goView(_ name: String) {
        var nextVC = UINavigationController()
        switch name {
        case "Start":
            nextVC = UINavigationController(rootViewController: SelectAreaStartViewController())
            
        case "List":
            nextVC = UINavigationController(rootViewController: SelectAreaListViewController())
            
        case "Setting":
            nextVC = UINavigationController(rootViewController: SelectAreaSettingViewController())
            
        case "Rule":
            nextVC = UINavigationController(rootViewController: SelectAreaRuleViewController())

        default:
            nextVC = UINavigationController()
        }
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
}

