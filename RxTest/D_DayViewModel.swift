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
    static let sharedInstance = D_DayViewModel()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    private var itemArray: [FinalData] = []
    
    func getCellData() -> Observable<[FinalData]> {
        if let dataArray = self.userDefaults.object(forKey: "dataName") as? [String] {
            let decoder = JSONDecoder()
            dataArray.map{
                print("\($0)")
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
}
