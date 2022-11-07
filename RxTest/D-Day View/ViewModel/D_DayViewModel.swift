//
//  D_DayViewModel.swift
//  RxTest
//
//  Created by Sean Kim on 2022/10/30.
//
import UIKit
import RxSwift
import RxCocoa


class D_DayViewModel {
//    static let sharedInstance = D_DayViewModel()
    
    private let userDefaults = UserDefaults.standard
    private let dataKey = "dataName"
    
//    private init() {}
    
    private var itemArray: [FinalData] = []
    
    func getCellData() -> Observable<[FinalData]> {
        if let dataArray = self.userDefaults.object(forKey: dataKey) as? [String] {
            let decoder = JSONDecoder()
            dataArray.map{
                if let loadedData = self.userDefaults.object(forKey: $0) as? Data {
                    if let decoded = try? decoder.decode(MainData.self, from: loadedData){
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let startDate = dateFormatter.date(from: decoded.startDate)!
                        let nowDate = dateFormatter.date(from: dateFormatter.string(from: Date()))!
                        let remainDate = Int(startDate.timeIntervalSince(nowDate) / 86400) // 1 Day = 86400 Sec
                        itemArray.append(.init(startDate: decoded.startDate,
                                               endDate: decoded.endDate,
                                               titleLabel: decoded.titleLabel,
                                               remainDate: remainDate))
                    }
                }
            }
        }
        return Observable.of(itemArray)
    }
    
    func removeCellData(_ keyValue: String) {
        self.userDefaults.removeObject(forKey: "\(keyValue)")
        if let titleCheck = self.userDefaults.object(forKey: dataKey) as? [String] {
            var check = titleCheck
            for i in 0 ..< check.count {
                if keyValue == check[i] {
                    check.remove(at: i)
                    self.userDefaults.set(check, forKey: dataKey)
                }
            }
        }
    }
    
    
    func addCellData(_ titleName: String, _ startDate: Date, _ endDate: Date) -> String {
        let encoder = JSONEncoder()
        let dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        let startTime = dateFormatter.string(from: startDate)
        let endTime = dateFormatter.string(from: endDate)
        
        if let titleArray = self.userDefaults.object(forKey: dataKey) as? [String] { // 이미 타이틀로 구성된 배열이 저장이 되어 있음
            var title = titleArray
            var hadSame = 0
            title.map {
                if $0 == titleName { return hadSame += 1 }
                return hadSame += 0
            }
            if hadSame > 0 { return "Same" }
            title.append(titleName)
            self.userDefaults.set(title, forKey: dataKey)
        } else {
            let title = [titleName]
            self.userDefaults.set(title, forKey: dataKey)
        }
        
        guard let checkData = self.userDefaults.object(forKey: titleName) as? Data else {
            if let encoded = try? encoder.encode(MainData(startDate: startTime, endDate: endTime, titleLabel: titleName)) {
                self.userDefaults.setValue(encoded, forKey: titleName)
            }
            return "Saved"
        }
        
        return "Error"
    }
}
