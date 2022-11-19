//
//  SelectAreaSettingModel.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/10.
//

import Foundation
import RxSwift
import RxCocoa

class SelectAreaSettingModel{
    
    private let userDefaults = UserDefaults.standard
    private var settingData = [SA_SetCellData]()// = []
    private var countNineArray = [Int]()
    private var countEightArray = [Int]()
    
    
    private let nineDo = ["경기", "강원", "충북", "충남", "전북", "전남", "경북", "경남", "제주"]
    private let eightCity = ["서울", "인천", "대전", "광주", "울산", "대구", "부산", "세종"]
    
    private var nineClick = [false, false, false, false, false, false, false, false, false]
    private var eightClick = [false, false, false, false, false, false, false, false]
    
    init(settingData: [SA_SetCellData] = [SA_SetCellData](), countNineArray: [Int] = [Int](), countEightArray: [Int] = [Int]()) {
        self.settingData = settingData
        self.countNineArray = countNineArray
        self.countEightArray = countEightArray
    }
    
    func getData() -> [setSection] {
        var countArray = countNineArray + countEightArray
        nineClick = [false, false, false, false, false, false, false, false, false]
        eightClick = [false, false, false, false, false, false, false, false]
        
        if let dataCheck = self.userDefaults.array(forKey: "setData") as? [Int] {
            // data 존재
            if countArray != dataCheck {
                self.countNineArray = Array(dataCheck[0...8])
                self.countEightArray = Array(dataCheck[9...16])
                countArray = countNineArray + countEightArray
            }
        } else {
            // data 부존재
            countArray = [10,10,10,10,10,10,10,10,10,
                          10,10,10,10,10,10,10,10]
            self.userDefaults.set(countArray, forKey: "setData")
        }
        
        return makeSection(nineName: nineDo, nineValue: Array(countArray[0...8]), nineClick: nineClick,
                           eightName: eightCity, eightValue: Array(countArray[9...16]), eightClick: eightClick)
    }
    
    func temporaryData(data : [Int]) -> [setSection] {
        if data[0] == 0 {
            countNineArray[data[1]] = data[2]
            nineClick[data[1]] = (data[3]==1 ? true : false)
        } else {
            countEightArray[data[1]] = data[2]
            eightClick[data[1]] = (data[3]==1 ? true : false)
        }
        
        return makeSection(nineName: nineDo, nineValue: countNineArray, nineClick: nineClick,
                           eightName: eightCity, eightValue: countEightArray, eightClick: eightClick)
        
    }
    
    func saveData() {
        if let dataCheck = self.userDefaults.array(forKey: "setData") as? [Int] {
            // data 존재
            let countArray = self.countNineArray + self.countEightArray
            self.userDefaults.set(countArray, forKey: "setData")
        } else {
            // data 부존재
            let countArray = [10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10]
            self.userDefaults.set(countArray, forKey: "setData")
        }
    }
    
    func resetData() -> [setSection] {
        nineClick = [false, false, false, false, false, false, false, false, false]
        eightClick = [false, false, false, false, false, false, false, false]
        self.countNineArray = [10,10,10,10,10,10,10,10,10]
        self.countEightArray = [10,10,10,10,10,10,10,10]
        
        return makeSection(nineName: nineDo, nineValue: countNineArray, nineClick: nineClick,
                           eightName: eightCity, eightValue: countEightArray, eightClick: eightClick)
        
        
    }
    
}

func makeSection(nineName: [String], nineValue: [Int], nineClick: [Bool], eightName: [String], eightValue: [Int], eightClick: [Bool]) -> [setSection] {
    return [
        setSection(headerTitle: "전국 8도",
                   items: {
                       var setData = [SA_SetCellData]()
                       for i in 0 ..< nineName.count {
                           setData.append(SA_SetCellData(cityName: nineName[i],
                                                         value: nineValue[i],
                                                         onClick: nineClick[i]))
                       }
                       return setData
                   }()
                  ),
        setSection(headerTitle: "광역시 / 특별시",
                   items: {
                       var setData = [SA_SetCellData]()
                       for i in 0 ..< eightName.count {
                           setData.append(SA_SetCellData(cityName: eightName[i],
                                                         value: eightValue[i],
                                                         onClick: eightClick[i]))
                       }
                       return setData
                   }()
                  ),
    ]
}
