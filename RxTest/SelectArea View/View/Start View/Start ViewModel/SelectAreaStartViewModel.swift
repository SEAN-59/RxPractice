//
//  SelectAreaStartViewModel.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/17.
//

class SelectAreaStartViewModel {
    private let model = SelectAreaStartModel()
    
    func getRatio() -> (Korea, Bool) {
        let data = model.getData()
        let randomValue = Int.random(in: 1 ... data.data.reduce(0, {$0 + $1}))
        var checkCollect: Int = 0
        for i in 0..<data.data.count{
            checkCollect += data.data[i]
            if randomValue <= checkCollect {
                checkCollect = i
                break
            }
        }
        let address = model.selectAddress(selectIndexNum: checkCollect)
        let result = model.saveListData(address: address)
        return (address, result)
    }
    func reset() {
        model.reset()
    }
    
    func read() {
        model.read()
    }
}
