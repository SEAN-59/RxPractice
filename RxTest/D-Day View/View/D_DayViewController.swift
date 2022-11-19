//
//  D_DayViewController.swift
//  RxTest
//
//  Created by Sean Kim on 2022/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class D_DayViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private lazy var tableView = UITableView()
    
    private lazy var addBarBtn : UIBarButtonItem = {
       let barBtn = UIBarButtonItem()
        barBtn.image = UIImage(systemName: "folder.badge.plus")
        barBtn.style = .plain
        barBtn.target = self
        barBtn.tintColor = .label
        return barBtn
    }()
    
    private lazy var backBarBtn : UIBarButtonItem = {
       let barBtn = UIBarButtonItem()
        barBtn.image = UIImage(systemName: "arrowshape.turn.up.backward")
        barBtn.style = .plain
        barBtn.target = self
        barBtn.tintColor = .label
        return barBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bind()
        attribute()
        layout()
    }
    
    public func bind(){
        
        
        addBarBtn.rx.tap.subscribe(onNext: {
            self.openAddView()
        }).disposed(by: disposeBag)
        
        backBarBtn.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true,completion: nil)
        }).disposed(by: disposeBag)
        
        
//        SelectAreaSettingViewModel().getCellData(false)
//            .bind(to: tableView.rx.items(cellIdentifier: SelectAreaSettingCell.reuseIdentifier,
//                                         cellType: SelectAreaSettingCell.self)){ row, element, cell in
//                print("Collect")
////                cell.cellNum = row
//                cell.cellNameLabel.text = "\(element.cityName)"
////                cell.cellCountLabel.text = "\(element.value)"
//            }.disposed(by: disposeBag)
        
        D_DayViewModel().getCellData()
            .bind(to: tableView.rx.items(cellIdentifier: D_DayViewCell.reuseIdentifier, cellType: D_DayViewCell.self)){ row, element, cell in
                cell.cellStartDateLabel.text = "\(element.startDate)"
                cell.cellEndDateLabel.text = "\(element.endDate)"
                cell.cellTitleLabel.text = "\(element.titleLabel)"

                if element.remainDate == 0 {
                    cell.remainDateLabel.text = "D - day"
                } else if element.remainDate < 0 {
                    cell.remainDateLabel.text = "D + \(element.remainDate * -1)"
                } else {
                    cell.remainDateLabel.text = "D - \(element.remainDate)"
                }
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated:true)
            }).disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(FinalData.self)
            .subscribe(onNext: { data in
                print("\(data)")
                D_DayViewModel().removeCellData(data.titleLabel)
            }).disposed(by: disposeBag)
        
        
        
        
    }
    
    private func attribute() {
        navigationController?.navigationBar.barTintColor = .systemBackground
        tableView.register(D_DayViewCell.self, forCellReuseIdentifier: D_DayViewCell.reuseIdentifier)
        tableView.rowHeight = 123
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

private extension D_DayViewController {
    private func setupNavigationBar() {
        navigationController?.navigationBar.barStyle = .default
        navigationItem.title = "D-Day"
        navigationItem.rightBarButtonItem = self.addBarBtn
        navigationItem.leftBarButtonItem = self.backBarBtn
    }
    
    private func openAddView() {
        let nextVC = D_DayAddViewController()
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .automatic
        self.present(nextVC,animated: true)
    }
}


