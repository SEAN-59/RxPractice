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
    let disposeBag = DisposeBag()
    static let reuseIdentifier = "SettingCell"
    
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

private extension SelectAreaSettingCell {
    private func bind() {
        
    }
    private func attribute() {
        
    }
    private func layout() {
        
    }
}
private extension SelectAreaSettingCell {
    
}
