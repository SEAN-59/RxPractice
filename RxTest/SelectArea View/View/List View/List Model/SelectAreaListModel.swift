//
//  SelectAreaListModel.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/11.
//

import Foundation

final class SelectAreaListModel {
    private let userDefaults = UserDefaults.standard
    
    func getCellData() -> ([SA_ListSection], Bool) {
        var outData = [SA_ListSection]()
        if let dataCheck = self.userDefaults.array(forKey: "SA_SaveDateData") as? [String] {
            for i in 0..<dataCheck.count {
                let stringToDate = DateFormatter()
                let dateToString = DateFormatter()
                stringToDate.dateFormat = "yyyy-MM-dd"
                dateToString.dateFormat = "MM"
                
                let title = Int(dateToString.string(from: stringToDate.date(from: dataCheck[i])!))!
                
                if let dataCheck = self.userDefaults.array(forKey: "\(dataCheck[i])") as? [String] {
                    if dataCheck.count == 5 {
                        outData.append(SA_ListSection(MonthTitle: title,
                                                                items: [SA_ListModel(startdate: dataCheck[0],
                                                                                     cityName: dataCheck[1],
                                                                                     sggName: dataCheck[2],
                                                                                     emdName: dataCheck[3],
                                                                                     endDate: dataCheck[4])]))
                    } else {
                        outData.append(SA_ListSection(MonthTitle: title,
                                                                items: [SA_ListModel(startdate: dataCheck[0],
                                                                                     cityName: dataCheck[1],
                                                                                     sggName: dataCheck[2],
                                                                                     emdName: dataCheck[3])]))
                        
                    }
                    return (outData, true)
                    
                }
            }
            
        } else {
            return (outData, false) // Data가 전혀 존재하지 않음을 뜻함
        }
        return (outData, false)
    }
    
    func confirmCellData(data: SA_ListModel) {
        if data.endDate == nil {
            if let dataCheck = self.userDefaults.array(forKey: data.startdate) as? [String] {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                var newData = dataCheck
                newData.append("\(dateFormatter.string(from: Date()))")
                self.userDefaults.set(newData, forKey: data.startdate)
            }
        } else {
            return 
        }
    }
            
    func deleteCellData(data: SA_ListModel) {
        if let dataCheck = self.userDefaults.array(forKey: data.startdate) as? [String] {
            self.userDefaults.removeObject(forKey: data.startdate)
        }
        
        if let dataCheck = self.userDefaults.array(forKey: "SA_SaveDateData") as? [String] {
            var newData = dataCheck
            newData.remove(at: dataCheck.firstIndex(of: data.startdate)!)
            self.userDefaults.set(newData, forKey: "SA_SaveDateData")
        }
    }
}
