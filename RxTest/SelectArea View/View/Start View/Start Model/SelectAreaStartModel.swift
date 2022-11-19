//
//  SelectAreaStartModel.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/17.
//

import Foundation

class SelectAreaStartModel {
    private let userDefaults = UserDefaults.standard
    private var address = Korea()
    
    private let city = ["경기도", "강원도", "충청북도", "충청남도", "전라북도", "전라남도", "경상북도", "경상남도", "제주특별자치도", "서울특별시", "부산광역시", "대구광역시", "인천광역시", "광주광역시", "대전광역시", "울산광역시", "세종특별시"]
    
    func getData() -> startSetData {
        if let dataCheck = self.userDefaults.array(forKey: "setData") as? [Int] {
            return startSetData.init(data: dataCheck, error: false)
        } else {
            return startSetData.init(data: [0], error: true)
        }
    }
    
    func selectAddress(selectIndexNum: Int) -> Korea {
        address.selectCityNm = city[selectIndexNum]
        address.selectSggNm = address.selectSgg()[Int.random(in: 0 ..< address.selectSgg().count)]
        address.selectEmdNm = address.selectEmd()[Int.random(in: 0 ..< address.selectEmd().count)]
        return self.address
    }
    
    func saveListData(address: Korea) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: Date())
        
        var saveDateData = [String]()
        
        
        if let dataCheck = self.userDefaults.array(forKey: "SA_SaveDateData") as? [String] {
            var check = [Bool]()
            check = dataCheck.map{
                if $0 == "\(todayDate)" { return false } // 똑같으면 저장하면 안되겠죠?
                return true
            }
            if check.filter({$0 == false}).count > 0 { return false }// 중복값이 있다는거
        }
        
        saveDateData.append("\(todayDate)")
        self.userDefaults.set(saveDateData, forKey: "SA_SaveDateData")
        
        if let dataCheck = self.userDefaults.array(forKey: "\(todayDate)") as? [String] {
            return false
        } else {
            let saveData = ["\(todayDate)","\(address.selectCityNm)","\(address.selectSggNm)","\(address.selectEmdNm)"]
            self.userDefaults.set(saveData, forKey: "\(todayDate)")
            return true
        }
    }
    
    func read() {
        if let dataCheck = self.userDefaults.array(forKey: "SA_SaveDateData") as? [String] {
            print(dataCheck)
            for i in 0..<dataCheck.count {
                if let dataCheck2 = self.userDefaults.array(forKey: dataCheck[i]) as? [String] {
                    print(dataCheck2)
                }
            }
        }
        
    }
    
    func reset() {
        
        if let dataCheck = self.userDefaults.array(forKey: "SA_SaveDateData") as? [String] {
            for i in 0..<dataCheck.count {
                if let dataCheck2 = self.userDefaults.array(forKey: dataCheck[i]) as? [String] {
                    self.userDefaults.removeObject(forKey: "\(dataCheck[i])")
                }
            }
            self.userDefaults.removeObject(forKey: "SA_SaveDateData")
        }
    }
}
