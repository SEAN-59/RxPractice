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
import RxDataSources


class SelectAreaSettingViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private var sectionRelay = BehaviorRelay(value: [setSection]())
    
    private var cityStaus: Bool = false
    
    private let viewModel = SelectAreaSettingViewModel()
    
// MARK: - Componets
    private lazy var setTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(SelectAreaSettingCell.self, forCellReuseIdentifier: SelectAreaSettingCell.reuseIdentifier)
        return tableView
    }()
    
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
    
    private lazy var areaSettingBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        button.isSizeUpBtn = true
        
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
        button.isSizeUpBtn = true
        
        button.setTitle("RESET", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    private lazy var areaFirstBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        button.isSizeUpBtn = true
        
        button.setTitle("처음으로", for: .normal)
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
    
    var dataSource = RxTableViewSectionedReloadDataSource<setSection> { dataSource, setTableView, indexPath, item in
        let cell = setTableView.dequeueReusableCell(withIdentifier: SelectAreaSettingCell.reuseIdentifier, for: indexPath) as! SelectAreaSettingCell
        cell.selectionStyle = .none
        cell.cityName = item.cityName
        cell.cellValue = item.value
        cell.cellIndex = [indexPath.section, indexPath.row]
        cell.onClick = item.onClick
        cell.initText()
        return cell
    }
// MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        attribute()
        layout()
        notiGroup()
    }
    
    
}

private extension SelectAreaSettingViewController {
    
    private func bind() {
        
        saveBtn.rx.tap
            .flatMap{self.showAlert(title: "저장",
                                    message: "저장하시겠습니까?",
                                    ok: "저장")}
            .bind(onNext: { alert in
                switch alert {
                case .ok:
                    self.viewModel.saveData()
                case .cancel:
                    break
                }
            }).disposed(by: disposeBag)
        
        areaResetBtn.rx.tap
            .flatMap{self.showAlert(title: "RESET",
                                    message: "초기화하시겠습니까?\n모든 데이터가 초기로 돌아갑니다.\n주의: 초기화 시 자동 저장",
                                    ok: "확인")}
            .bind(onNext: { alert in
                switch alert {
                case .ok:
                    self.accept(set: self.viewModel.resetData())
                case .cancel:
                    break
                }
            }).disposed(by: disposeBag)
        
        
        areaFirstBtn.rx.tap
            .flatMap{self.showAlert(title: "처음으로",
                                    message: "처음으로 돌리시겠습니까?\n모든 데이터가 처음으로 돌아갑니다.",
                                    ok: "확인")}
            .bind(onNext: { alert in
                switch alert {
                case .ok:
                    self.sectionRelay.accept(self.viewModel.getCellData())
                case .cancel:
                    break
                }
            }).disposed(by: disposeBag)
        
        
        backBtn.rx.tap.bind{
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
// MARK: - SetTableView
        setTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        sectionRelay.accept(viewModel.getCellData())
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].headerTitle
        }
        
        sectionRelay
            .bind(to: setTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
    }// bind END
    
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
        
        
        self.setTableView.rowHeight = 50
        
    }
    private func layout() {
        view.addSubview(contentsView)
        
        contentsView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        [
            setTableView,
            areaResetBtn,
            areaFirstBtn
        ].forEach{contentsView.addSubview($0)}
        
        setTableView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.bottom.equalTo(areaResetBtn.snp.top).offset(-16.0)
        }
        areaFirstBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(24.0)
            $0.trailing.equalTo(contentsView.snp.centerX).offset(-8.0)
        }
        
        areaResetBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16.0)
            $0.leading.equalTo(contentsView.snp.centerX).offset(8.0)
            $0.trailing.equalToSuperview().inset(24.0)
        }
        
        
    }
    
    func notiGroup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cellData),
                                               name: NSNotification.Name("SendSettingCellData"),
                                               object: nil)
    }
}
private extension SelectAreaSettingViewController {
    @objc func cellData(_ notification: Notification) {
        guard let data = notification.object as? [Int] else { return }
//        sectionRelay.accept(self.viewModel.upDateCellData(data: data))
        accept(set: self.viewModel.upDateCellData(data: data))
    }
    
    func accept(set: [setSection]) {
        sectionRelay.accept(set)
    }
    
    private func showAlert(title: String, message: String, ok: String) -> Observable<SA_saveAlert> {
        return Observable.create{ [weak self] Observer in
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "취소", style: .destructive) { _ in
                Observer.onNext(.cancel)
                Observer.onCompleted()
            }
            
            let okAction = UIAlertAction(title: ok, style: .default) { _ in
                Observer.onNext(.ok)
                Observer.onCompleted()
            }
            
            [okAction,cancelAction].forEach{alertController.addAction($0)}
            
            self?.present(alertController, animated: true, completion: nil)
            
            return Disposables.create {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
extension SelectAreaSettingViewController: UITableViewDelegate {
}
