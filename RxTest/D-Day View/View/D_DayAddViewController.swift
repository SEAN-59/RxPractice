//
//  D_DayAddViewController.swift
//  RxTest
//
//  Created by Sean Kim on 2022/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class D_DayAddViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    private lazy var contentsView = UIView()
    
    private lazy var mainTitleTxf: UITextField = {
        let textField = UITextField()
        
        textField.font = .systemFont(ofSize: 30.0, weight: .regular)
        textField.placeholder = "제목을 입력해주세요"
        textField.textAlignment = .center
        textField.backgroundColor = .systemBackground
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10.0
        textField.tintColor = .clear
        
        return textField
    }()
    
    private lazy var separatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private lazy var selectDateView = UIView()
    private lazy var selectFirstLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textColor = .label
        label.text = "날짜"
        
        return label
    }()
    
    private lazy var selectSecondLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textColor = .label
        label.isHidden = true
        label.text = "종료일"
        
        return label
    }()
    
    
    private lazy var selectFirstDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        return datePicker
    }()
    
    private lazy var selectSecondDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.isHidden = true
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        
        return datePicker
    }()
    
    private lazy var periodLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .label
        label.text = "기간으로 설정"
        
        return label
    }()
    
    private lazy var checkPeriodSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        return sw
    }()
    
    private lazy var periodStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        [
            periodLabel,
            checkPeriodSwitch
        ].forEach { stackView.addArrangedSubview($0) }
        
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        attribute()
        layout()
    }
    
    private lazy var saveBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("저장", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)

        return button
    }()
    
    private func bind() {
        checkPeriodSwitch.rx.controlEvent(.valueChanged)
            .withLatestFrom(checkPeriodSwitch.rx.value)
            .subscribe(onNext: { check in
                if check {
                    self.selectSecondDatePicker.isHidden = false
                    self.selectSecondLabel.isHidden = false
                    self.selectFirstLabel.text = "시작일"
                    
                } else {
                    self.selectFirstLabel.text = "날짜"
                    self.selectSecondDatePicker.isHidden = true
                    self.selectSecondLabel.isHidden = true
                }
                self.datePickerLayout()
            }).disposed(by: disposeBag)
        
        saveBtn.rx.tap
            .subscribe(onNext : {
                self.saveData()
            }).disposed(by: disposeBag)
        
        selectFirstDatePicker.rx.date // 종료일이 시작일보다 앞으로 갈 수 없게 만든거임
            .bind(to: selectSecondDatePicker.rx.minimumDate)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        view.addSubview(contentsView)
        contentsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        [
            mainTitleTxf,
            separatorView,
            periodStackView,
            selectDateView,
            saveBtn
        ].forEach{contentsView.addSubview($0)}
        
        mainTitleTxf.snp.makeConstraints{
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.trailing.equalToSuperview().inset(8.0)
        }
        
        separatorView.snp.makeConstraints{
            $0.top.equalTo(mainTitleTxf.snp.bottom).offset(8.0)
            $0.height.equalTo(1.0)
            $0.leading.trailing.equalTo(mainTitleTxf)
        }
        
        periodStackView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(16.0)
            $0.leading.trailing.equalTo(mainTitleTxf)
        }
        
        selectDateView.snp.makeConstraints {
            $0.top.equalTo(periodStackView.snp.bottom).offset(16.0)
            $0.leading.trailing.equalTo(mainTitleTxf)
            $0.bottom.equalTo(saveBtn.snp.top).offset(-16.0)
        }
        
        saveBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32.0)
            $0.centerX.equalToSuperview()
        }
        
        
        
        [
            selectFirstLabel,
            selectFirstDatePicker,
            selectSecondLabel,
            selectSecondDatePicker
        ].forEach{selectDateView.addSubview($0)}
        self.datePickerLayout()
    }
    
    private func datePickerLayout() {
        
        if selectSecondDatePicker.isHidden {
            selectFirstLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
            }
            selectFirstDatePicker.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(selectFirstLabel.snp.bottom).offset(8.0)
            }
        } else {
            selectFirstLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
            }
            selectFirstDatePicker.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(selectFirstLabel.snp.bottom).offset(8.0)
            }
            
            selectSecondLabel.snp.makeConstraints {
                $0.top.equalTo(selectFirstDatePicker.snp.bottom).offset(8.0)
                $0.leading.trailing.equalToSuperview()
            }
            
            selectSecondDatePicker.snp.makeConstraints {
                $0.top.equalTo(selectSecondLabel.snp.bottom).offset(8.0)
                $0.leading.trailing.equalToSuperview()
            }
            
        }
    }
}

private extension D_DayAddViewController  {
    private func saveData()  {
        
        guard let titleName = self.mainTitleTxf.text else { return }
        
        if titleName.isEmpty {
            return
        }
        
        if let dataArray = self.userDefaults.object(forKey: "dataName") as? [String] {
            var titleTxf = dataArray
            titleTxf.append(titleName)
            self.userDefaults.set(titleTxf, forKey: "dataName")
        }else {
            let titleTxf = [titleName]
            self.userDefaults.set(titleTxf, forKey: "dataName")
        }

        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var firstTimeDate = String()
        var secondTimeDate = String()

        selectFirstDatePicker.rx.value
            .subscribe(onNext: { date in
                firstTimeDate = dateFormatter.string(from: date)
            }).disposed(by: disposeBag)

        selectSecondDatePicker.rx.value.subscribe(onNext: { date in
            secondTimeDate = dateFormatter.string(from: date)
        }).disposed(by: disposeBag)

        let collectData = MainData(startDate: firstTimeDate, endDate: secondTimeDate, titleLabel: titleName)

        guard let checkData = self.userDefaults.object(forKey: titleName) as? Data else { // 없을 경우 이리 들어갈거임
            if let encoded = try? encoder.encode(collectData) {
                self.userDefaults.setValue(encoded, forKey: titleName)
            }
            return
        }
    }
}
