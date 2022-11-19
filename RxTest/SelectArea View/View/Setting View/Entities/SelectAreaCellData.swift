//
//  SelectAreaCellData.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/09.
//

import Foundation
import RxDataSources

// MARK: -
struct SA_SetCellData {
    var cityName: String
    var value: Int
    var onClick: Bool
}

extension SA_SetCellData: IdentifiableType, Equatable {
    var identity: String { return cityName }
}

struct setSection {
    var headerTitle: String
    var items: [Item]
}

extension setSection: AnimatableSectionModelType {
    typealias Item = SA_SetCellData
    
    var identity: String { return headerTitle }
    
    init(original: setSection, items: [SA_SetCellData]) {
        self = original
        self.items = items
    }
    
}
// MARK: -
enum SA_saveAlert {
    case ok
    case cancel
}
