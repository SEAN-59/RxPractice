//
//  D_DayCelData.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/01.
//

import Foundation

struct MainData: Codable {
    let startDate: String
    let endDate: String
    let titleLabel: String
}

struct FinalData{
    let startDate: String
    let endDate: String
    let titleLabel: String
    let remainDate: Int
}
