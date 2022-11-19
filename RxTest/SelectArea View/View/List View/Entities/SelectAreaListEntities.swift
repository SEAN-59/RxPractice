//
//  SelectAreaListEntities.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/18.
//

import Foundation
import RxDataSources

struct SA_ListModel {
    var startdate: String
    var cityName: String
    var sggName: String
    var emdName: String
    var endDate: String?
}
extension SA_ListModel: IdentifiableType, Equatable {
    var identity: String { return startdate }
}

struct SA_ListSection {
    var MonthTitle: Int
    var items: [Item]
}

extension SA_ListSection: AnimatableSectionModelType {
    typealias Item = SA_ListModel
    
    var identity: Int { return MonthTitle}
    
    init(original: SA_ListSection, items: [SA_ListModel]) {
        self = original
        self.items = items
    }
}

enum SA_ListMode {
    case none
    case confirm
    case delete
}

enum SA_ListLoad {
    case none
    case load
}
