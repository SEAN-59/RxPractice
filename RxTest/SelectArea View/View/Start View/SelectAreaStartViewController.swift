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
    private var changeAnimation = false
    let disposeBag = DisposeBag()
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
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
        button.isSizeChangeBtn = true
        button.setTitle("START", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 50.0, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15.0
        button.layer.borderColor = UIColor.label.cgColor
        button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        return button
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
        startBtn.rx.tap.bind{
            self.changeAnimation.toggle()
            print(self.changeAnimation)
            self.playAnimation(self.changeAnimation)
        }.disposed(by: disposeBag)
        
    }
    private func attribute() {
        
    }
    private func layout() {
        view.addSubview(contentsView)
        contentsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [
            mapSearchAnimationView,
            trainAnimationView,
            startBtn
        ].forEach{ contentsView.addSubview($0)}
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
    private func playAnimation(_ state: Bool) {
        if state {
            print("state: \(mapSearchAnimationView.isAnimationPlaying)")
            mapSearchAnimationView.stop()
            [mapSearchAnimationView,trainAnimationView].forEach{$0.isHidden.toggle()}
            trainAnimationView.play(completion: { completed in
                // 버튼 누르게 되면 time 재서 그 타임 만큼 강제로 쉬게 했다가 데이터 불러오면 if 에서 반환값이랑 비교하는거로
            })
        } else {
            trainAnimationView.stop()
            [mapSearchAnimationView,trainAnimationView].forEach{$0.isHidden.toggle()}
            mapSearchAnimationView.play()
        }
    }
    
}

extension LottieAnimationView {
    
}
