//
//  SelectAreaListCell.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectAreaListCell: UITableViewCell {
    let disposeBag = DisposeBag()
    static let reuseIdentifier = "ReportCell"
    
    private lazy var startDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textColor = .blue
        label.text = ""
        
        return label
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .label
        label.text = ""
        
        return label
    }()
    
    private lazy var sggNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .label
        label.text = ""
        
        return label
    }()
    
    private lazy var emdNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .label
        label.text = ""
        return label
    }()
    
    private lazy var endDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textColor = .red
        label.text = ""
        
        return label
    }()
    
    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4.0
        
        [
            cityNameLabel,
            sggNameLabel,
            emdNameLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.bind()
        self.attribute()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SelectAreaListCell {
    func bind() {
    }
    private func attribute() {
    }
    private func layout() {
        [
            startDateLabel,
            endDateLabel,
            addressStackView
        ].forEach{contentView.addSubview($0)}
        
        startDateLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(addressStackView.snp.top).offset(-8.0)
        }
        endDateLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(16.0)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(addressStackView.snp.top).offset(-8.0)
        }
        addressStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(contentView.snp.centerY).offset(-4.0)
            $0.bottom.equalToSuperview().inset(4.0)
        }
    }
}
extension SelectAreaListCell {
    func initText(startDate: String, cityName: String, sggName: String, emdName: String, endDate: String?) {
        self.startDateLabel.text = "\(startDate)"
        self.cityNameLabel.text = "\(cityName)"
        self.sggNameLabel.text = "\(sggName)"
        self.emdNameLabel.text = "\(emdName)"
        if endDate != nil {
            self.endDateLabel.text = "\(endDate!)"
        }
        
    }
    
}
