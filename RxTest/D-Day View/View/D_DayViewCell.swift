//
//  D_DayViewCell.swift
//  RxTest
//
//  Created by Sean Kim on 2022/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class D_DayViewCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    static let reuseIdentifier = "ListCell"
    
    lazy var cellStartDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textColor = .label
        label.text = "날짜"
        
        return label
    }()
    
    lazy var cellEndDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textColor = .label
        label.text = "날짜"
        
        return label
    }()
    
    private lazy var cellDateStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        
        [
            cellStartDateLabel,
            cellEndDateLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    lazy var cellTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .label
        label.text = "제목"
        
        return label
    }()
    
    lazy var remainDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .label
        label.text = "0%"
        
        return label
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
    
    private func bind() {
        
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        [
            cellDateStackView,
            cellTitleLabel,
            remainDateLabel
        ].forEach{addSubview($0)}
        
        cellDateStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        cellTitleLabel.snp.makeConstraints {
            $0.top.equalTo(cellDateStackView.snp.bottom).offset(8.0)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.0)
        }
        remainDateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(8.0)
        }
    }
}

