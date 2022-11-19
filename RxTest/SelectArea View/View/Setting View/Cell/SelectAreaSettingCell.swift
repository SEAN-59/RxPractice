//
//  SelectAreaSettingCell.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectAreaSettingCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    static let reuseIdentifier = "SettingCell"
    
    var cityName = String()
    var cellIndex = [Int]()
    var cellValue = Int()
    var onClick = Bool()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        
        [
            cellNameLabel,
            cellCountLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var cellNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .label
        label.text = ""
        
        return label
    }()
    
    private lazy var cellCountLabel: UILabel = {
        let label = UILabel()
//
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .label
        label.text = ""
        
        return label
    }()
    
    private lazy var btnStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        
        [
            countPlusBtn,
            countMinusBtn
        ].forEach { stackView.addArrangedSubview($0) }
        
        countPlusBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        countMinusBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        return stackView
    }()
    
    private lazy var countPlusBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        
        button.isSizeDownBtn = true
        
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    private lazy var countMinusBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        
        button.isSizeDownBtn = true
        
        button.setTitle("-", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    private lazy var setMultiSegBtn: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["x1","x10"])
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = .systemBackground
        seg.layer.borderColor = UIColor.label.cgColor
        seg.layer.borderWidth = 1.0
        seg.layer.cornerRadius = 5.0
        return seg
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension SelectAreaSettingCell {
    private func bind() {
        countPlusBtn.rx.tap
            .bind{
                self.cellValue += self.setMultiSegBtn.selectedSegmentIndex == 0 ? 1 : 10
                self.cellCountLabel.text = "\(self.cellValue)"
                self.sendData()
            }.disposed(by: disposeBag)
        
        countMinusBtn.rx.tap
            .bind{
                if (self.cellValue - (self.setMultiSegBtn.selectedSegmentIndex == 0 ? 1 : 10)) <= 0{
                    self.cellValue = 0
                } else {
                    self.cellValue -= self.setMultiSegBtn.selectedSegmentIndex == 0 ? 1 : 10
                }
                self.cellCountLabel.text = "\(self.cellValue)"
                self.sendData()
            }.disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        self.setMultiSegBtn.selectedSegmentIndex = 0
        
    }
    private func layout() {
        [
            titleStackView,
            btnStackView,
            setMultiSegBtn
        ].forEach{contentView.addSubview($0)}
        
        titleStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.leading.bottom.equalToSuperview().inset(8.0)
            
        }
        
        btnStackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(countPlusBtn.snp.width)
        }
        
        setMultiSegBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8.0)
        }
        
    }
}
extension SelectAreaSettingCell {
    func initText() {
        self.cellNameLabel.text = "\(cityName) :"
        self.cellCountLabel.text = "\(cellValue)"
        self.onClick ? (self.setMultiSegBtn.selectedSegmentIndex = 1) : (self.setMultiSegBtn.selectedSegmentIndex = 0)
    }
    
}

private extension SelectAreaSettingCell {
    private func sendData() {
        NotificationCenter.default.post(name: NSNotification.Name("SendSettingCellData"),
                                        object: [cellIndex[0],cellIndex[1],cellValue,(self.setMultiSegBtn.selectedSegmentIndex == 0) ? 0 : 1 ],
                                        userInfo: nil)
    }
}

