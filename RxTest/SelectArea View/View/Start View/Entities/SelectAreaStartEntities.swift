//
//  SelectAreaStartEntities.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/17.
//

import Foundation
import RxSwift
import RxCocoa

enum CheckLottie {
    case play
    case stop
}

struct startSetData{
    var data: [Int]
    var error: Bool // true 이면 문제가 있는것
}

struct SA_SaveData{
    var date: String
    var address: Korea
}

enum SA_StartShowAlert {
    case ok
}
