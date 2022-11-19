//
//  SelectAreaSettingViewModel.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/10.
//

//import UIKit
//import RxSwift
//import RxCocoa

class SelectAreaSettingViewModel {
    private let model = SelectAreaSettingModel()
    
    private var itemArray = [setSection]()
    
    init(itemArray: [setSection] = [setSection]()) {
        self.itemArray = itemArray
    }
    
    func getCellData() -> [setSection] {
        return model.getData()// subject
    }
    
    func upDateCellData(data: [Int]) -> [setSection] {
        return model.temporaryData(data: data)
    }
    
    func saveData() {
        model.saveData()
    }
    
    func resetData() -> [setSection] {
        let set = model.resetData()
        self.saveData()
        return set
    }
    
    
}

