//
//  SelectAreaListViewController.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class SelectAreaListViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = SelectAreaListViewModel()
    private var cellData = SA_ListModel(startdate: "", cityName: "", sggName: "", emdName: "")
    
    private lazy var contentsView = UIView()
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(SelectAreaListCell.self, forCellReuseIdentifier: SelectAreaListCell.reuseIdentifier)
        tableView.backgroundColor = .systemBackground
        tableView.separatorColor = .systemGray
        tableView.sectionIndexBackgroundColor = .systemGray2
        tableView.rowHeight = 80
        return tableView
    }()
    
    
    private lazy var backBtn : UIBarButtonItem = {
        let barBtn = UIBarButtonItem()
        barBtn.image = UIImage(systemName: "arrowshape.turn.up.backward")
        barBtn.style = .plain
        barBtn.target = self
        barBtn.tintColor = .label
        return barBtn
    }()
    
    private var section = BehaviorRelay(value: [SA_ListSection]())
    
    private let changeMode = BehaviorRelay(value: SA_ListMode.none)
    
    private let loadData = BehaviorRelay(value: SA_ListLoad.none)
    
    private var dataSource = RxTableViewSectionedReloadDataSource<SA_ListSection> {
        dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectAreaListCell.reuseIdentifier, for: indexPath) as! SelectAreaListCell
        cell.selectionStyle = .none
        cell.initText(startDate: item.startdate, cityName: item.cityName, sggName: item.sggName, emdName: item.emdName, endDate: item.endDate)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.attribute()
        self.layout()
    }
    
}

private extension SelectAreaListViewController {
    private func bind() {
        backBtn.rx.tap
            .bind{
                self.dismiss(animated: true)
            }.disposed(by: disposeBag)
        
        changeMode
            .observe(on:MainScheduler.asyncInstance)
            .subscribe(onNext: { state in
                switch state {
                case .none:
                    return
                case .confirm:
                    self.viewModel.confirmData(data: self.cellData)
                    self.changeMode.accept(.none)
                case .delete:
                    self.viewModel.deleteData(data: self.cellData)
                    self.changeMode.accept(.none)
                }
                self.loadData.accept(.load)

            }).disposed(by: disposeBag)
        
        loadData
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { state in
                switch state{
                case .none:
                    return
                case .load:
                    let cellData = self.viewModel.getCellData()
                    if cellData.1 {
                        self.section.accept(cellData.0)
                    } else {
                        self.section.accept([SA_ListSection]())
                        self.showAlert(title: "정보 없음", message: "START에서 정보를 입력하세요.")
                            .bind(onNext: {
                                self.dismiss(animated: true)
                            })
                            .disposed(by: self.disposeBag)
                    }
                    self.loadData.accept(.none)
                }
            }).disposed(by: disposeBag)
        
        
        // MARK: - TableView
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        loadData.accept(.load)
        
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return "\(dataSource.sectionModels[index].MonthTitle) 월"
        }
        
        dataSource.canEditRowAtIndexPath = { dataSource, index -> Bool in
            return true
        }
        
        section
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.barStyle = .default
        navigationItem.leftBarButtonItem = self.backBtn
        
        
    }
    private func layout() {
        view.addSubview(contentsView)
        contentsView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        contentsView.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        
    }
}
private extension SelectAreaListViewController {
    private func showAlert(title: String, message: String) -> Observable<Void> {
        return Observable.create{
            Observer in
            let alertVC = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "확안", style: .destructive){ _ in
                Observer.onNext(())
                Observer.onCompleted()
            }
            
            alertVC.addAction(okAction)
            
            self.present(alertVC, animated: true)
            
            return Disposables.create {
                alertVC.dismiss(animated: true)
            }
        }
    }
    
    private func tableViewDrag(_ tableView: UITableView, _ indexPath: IndexPath) -> Observable<SA_ListModel> {
        return Observable.create{ Observer in
            do {
                Observer.onNext(try tableView.rx.model(at: indexPath))
                Observer.onCompleted()
            }
            catch {
                Observer.onError(error)
            }
            return Disposables.create()
        }
    }
}

extension SelectAreaListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let confirmAction = UIContextualAction(style: .normal,
                                               title: "완료") { (action, view, completionHandelr) in
            completionHandelr(true)
            self.tableViewDrag(tableView, indexPath)
                .bind(onNext: { model in
                    self.cellData = model
                    self.changeMode.accept(.confirm)
                }).disposed(by: self.disposeBag)
            
        }
        
        confirmAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [confirmAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "삭제") { (action, view, completionHandelr) in
            completionHandelr(true)
            self.tableViewDrag(tableView, indexPath)
                .bind(onNext: { model in
                    self.cellData = model
                    self.changeMode.accept(.delete)
                }).disposed(by: self.disposeBag)
            
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
