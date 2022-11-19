//
//  SelectAreaListViewModel.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/11.
//

import Foundation

final class SelectAreaListViewModel {
    private let model = SelectAreaListModel()
    
    func getCellData() -> ([SA_ListSection], Bool) {
        return model.getCellData()
    }
    
    func deleteData(data: SA_ListModel) {
        self.model.deleteCellData(data: data)
        
    }
    
    func confirmData(data: SA_ListModel) {
        self.model.confirmCellData(data: data)
        
    }
}
