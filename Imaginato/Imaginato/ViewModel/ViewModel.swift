//
//  ViewModel.swift
//  Imaginato
//
//  Created by Prince Sojitra on 08/12/20.
//  Copyright © 2020 Asha Patel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class DiaryViewModel {
    
    let arrDiary = BehaviorSubject(value: [Diary]())
            
    func fetchData() {
       if let url = URL(string: "https://private-ba0842-gary23.apiary-mock.com/notes") {
          URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
               do {
                let arrTemp = try JSONDecoder().decode([Diary].self, from: data)
                
                let diary = arrTemp.sorted(by: { $0.date.toDate()?.compare($1.date.toDate() ?? Date()) == .orderedDescending })
                self.arrDiary.onNext(Sectionfilter(arr: diary))
                SaveDataToUserDefaults()

               } catch let error {
                 print(error)
               }
            }
          }.resume()
       }
    }
}



func Sectionfilter(arr : [Diary]) -> [Diary]{
    var arrTemp = arr
    for obj in arrTemp{
        let month = obj.date.toDateString()
        if arrTemp.filter({$0.date.toDateString() == month && $0.isShow == true}).count != 0{
            
        }
        else{
            if let index = arrTemp.firstIndex(where: {$0.date.toDateString() == month}){
                arrTemp[index].isShow = true
            }
        }
    }
    return arrTemp
}


func SaveDataToUserDefaults() {
    
    if let value = try? viewModel.arrDiary.value(){
        do {
           let jsonData = try JSONEncoder().encode(value)
           UserDefaults.standard.set(jsonData, forKey: "diary")
    
        } catch let error {
          print(error)
        }
    }

}

func FetchDataToUserDefaults(){
    
    if let diaryData = UserDefaults.standard.object(forKey: "diary") as? Data{
        do {
        let arrTemp = try JSONDecoder().decode([Diary].self, from: diaryData)
        let diary = arrTemp.sorted(by: { $0.date.toDate()?.compare($1.date.toDate() ?? Date()) == .orderedDescending })
        viewModel.arrDiary.onNext(Sectionfilter(arr: diary))
        } catch let error {
            print(error)
        }
    }
}



