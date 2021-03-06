//
//  Model.swift
//  Imaginato
//
//  Created by Prince Sojitra on 08/12/20.
//  Copyright © 2020 Asha Patel. All rights reserved.
//

import Foundation



struct Diary : Decodable,Encodable{
    var id, title, content, date: String
    var isShow : Bool? = false
    
    
    var DiaryListRepresentation : [String:String] {
        return ["id" : id, "title" : title, "content" : content, "date" : date]
    }
    
}

