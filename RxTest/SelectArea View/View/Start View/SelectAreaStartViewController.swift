//
//  SelectAreaStartViewController.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Lottie

final class SelectAreaStartViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = SelectAreaStartViewModel()
    
    //    private var changeAnimation = false
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 45.0, weight: .bold)
        label.textColor = .label
        label.text = "어디로 떠나볼까요?"
        
        return label
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 35.0, weight: .bold)
        label.textColor = .label
        label.text = ""
        
        return label
    }()
    
    private lazy var sggLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 35.0, weight: .bold)
        label.textColor = .label
        label.text = ""
        
        return label
    }()
    
    private lazy var emdLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 35.0, weight: .bold)
        label.textColor = .label
        label.text = ""
        
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 12.0
        stackView.isHidden = true
        [
            cityLabel,
            sggLabel,
            emdLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var trainAnimationView: LottieAnimationView = { //1 ~89 까지만
        let aniView : LottieAnimationView = .init(name: "fastTrain")
        aniView.isHidden = true
        return aniView
    }()
    
    private lazy var mapSearchAnimationView: LottieAnimationView = {
        let aniView : LottieAnimationView = .init(name: "mapSearch")
        aniView.backgroundBehavior = .pauseAndRestore
        aniView.loopMode = .loop
        aniView.animationSpeed = 0.5
        return aniView
    }()
    
    
    private lazy var startBtn: ChangeButtonClicked = {
        let button = ChangeButtonClicked()
        button.isSizeUpBtn = true
        button.setTitle("START", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 50.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15.0
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.attribute()
        self.layout()
        mapSearchAnimationView.play()
    }
    
}

private extension SelectAreaStartViewController {
    private func bind() {
        backBtn.rx.tap.bind{
            self.viewModel.read()
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        startBtn.rx.tap
            .flatMap{ self.checkLottie(lottie: self.trainAnimationView)
            }.subscribe(onNext: {[weak self] state in
                guard let self = self else { return }
                switch state{
                case .play:
                    self.questionLabel.text = "어디로 떠나볼까요?"
                    self.startBtn.setTitle(".....", for: .normal)
                    if self.trainAnimationView.isHidden && self.mapSearchAnimationView.isHidden {
                        self.trainAnimationView.isHidden.toggle()
                        self.labelStackView.isHidden.toggle()
                    } else if self.trainAnimationView.isHidden {
                        self.mapSearchAnimationView.stop()
                        self.mapSearchAnimationView.isHidden.toggle()
                        self.trainAnimationView.isHidden.toggle()
                    }

                case .stop:
                    self.trainAnimationView.isHidden.toggle()
                    let modelValue = self.viewModel.getRatio()
                    self.setLableValue(address: modelValue.0)
                    guard modelValue.1 else {
                        self.showAlert(title: "저장 오류", message: "아직 여행을 떠나지 않으셨어요~").bind(onNext: {_ in
                        })
                        return
                    } // true 이면 정상 저자

                }

            }).disposed(by: disposeBag)

        
        
    }
    private func attribute() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.barStyle = .default
        navigationItem.leftBarButtonItem = self.backBtn
        
    }
    private func layout() {
        view.addSubview(contentsView)
        contentsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [
            questionLabel,
            labelStackView,
            mapSearchAnimationView,
            trainAnimationView,
            startBtn
        ].forEach{ contentsView.addSubview($0)}
        
        questionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(mapSearchAnimationView.snp.top).offset(-64.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        labelStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        mapSearchAnimationView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        trainAnimationView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        startBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(144.0)
            $0.leading.trailing.equalToSuperview().inset(32.0)
        }
    }
}
private extension SelectAreaStartViewController {
    
    private func setLableValue(address: Korea) {
        [labelStackView].forEach{$0.isHidden.toggle()}
        questionLabel.text = "이번 여행지는 바로!"
        cityLabel.text = "\(address.selectCityNm)"
        sggLabel.text = "\(address.selectSggNm)"
        emdLabel.text = "\(address.selectEmdNm)"
        startBtn.setTitle("RESTART", for: .normal)
    }
    
    private func checkLottie(lottie: LottieAnimationView) -> Observable<CheckLottie> {
        return Observable.create { Observer in
            do {
                guard lottie.isAnimationPlaying else {
                    Observer.onNext(.play)
                    lottie.play(completion: { _ in
                        Observer.onNext(.stop)
                        Observer.onCompleted()
                    })
                    return Disposables.create()
                }
                Observer.onCompleted()
            } catch {
                Observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    private func showAlert(title: String, message: String) -> Observable<SA_StartShowAlert>{
        return Observable.create{ [weak self] Observer in
            let alertVC = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in
                Observer.onNext(.ok)
                Observer.onCompleted()
            }
            
            [okAction].forEach{alertVC.addAction($0)}
            
            self?.present(alertVC, animated: true)
            
            return Disposables.create{
                alertVC.dismiss(animated: true)
            }
        }
    }
    
}
