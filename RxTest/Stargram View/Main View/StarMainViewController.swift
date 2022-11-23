//
//  StarMainViewController.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class StarMainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = StarMainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.attribute()
        self.layout()
    }
    
}

private extension StarMainViewController {
    private func bind() {
        let nextVC = UINavigationController(rootViewController: StarLoginViewController())
        present(nextVC, animated: true)
        
    }
    private func attribute() {
        
    }
    private func layout() {
        
    }
}
private extension StarMainViewController {
    
}

extension StarMainViewController {
    
}
