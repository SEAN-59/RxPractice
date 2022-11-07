//
//  SelectAreaSettingViewController.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectAreaSettingViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private lazy var contentsView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40.0, weight: .bold)
        label.textColor = .label
        label.text = "설정"
        return label
    }()

    private lazy var setSegBtn: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["특별시/광역시", "전국 8도"])
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = .systemGroupedBackground
        seg.layer.borderColor = UIColor.lightGray.cgColor
        seg.layer.borderWidth = 1.0
        seg.layer.cornerRadius = 5.0
        return seg
    }()
    
    private lazy var setTableView = UITableView()
    
    private lazy var areaSettingBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        button.isSizeChangeBtn = true
        
        button.setTitle("지역 설정", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    private lazy var areaResetBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        button.isSizeChangeBtn = true
        
        button.setTitle("RESET", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    private lazy var backBtn : UIBarButtonItem = {
        let barBtn = UIBarButtonItem()
        barBtn.image = UIImage(systemName: "arrowshape.turn.up.backward")
        barBtn.style = .plain
        barBtn.target = self
        barBtn.tintColor = .label
        return barBtn
    }()
    
    private lazy var saveBtn : UIBarButtonItem = {
        let barBtn = UIBarButtonItem()
        barBtn.image = UIImage(systemName: "folder.badge.plus")
        barBtn.style = .plain
        barBtn.target = self
        barBtn.tintColor = .label
        return barBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.attribute()
        self.layout()
    }
    
}

private extension SelectAreaSettingViewController {
    private func bind() {
        saveBtn.rx.tap.bind{
            
        }.disposed(by: disposeBag)
        
        backBtn.rx.tap.bind{
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        setSegBtn.rx.selectedSegmentIndex
            .bind{
            print("??: \($0)")
        }.disposed(by: disposeBag)
    }
    private func attribute() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.barStyle = .default
        navigationItem.title = "설정"
        navigationItem.rightBarButtonItem = self.saveBtn
        navigationItem.leftBarButtonItem = self.backBtn
        
        self.setTableView.backgroundColor = .systemGroupedBackground
        self.setTableView.layer.cornerRadius = 5.0
        self.setTableView.layer.borderColor = UIColor.lightGray.cgColor
        self.setTableView.layer.borderWidth = 1.0
        self.setTableView.separatorColor = .lightGray
        
    }
    private func layout() {
        view.addSubview(contentsView)
        
        contentsView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        [
            setSegBtn,
            setTableView,
            areaResetBtn
        ].forEach{contentsView.addSubview($0)}
        
        setSegBtn.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
        }
        
        areaResetBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
        }
        
        setTableView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(setSegBtn.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.bottom.equalTo(areaResetBtn.snp.top).offset(-16.0)
        }
        
    }
}
private extension SelectAreaSettingViewController {
    
}
