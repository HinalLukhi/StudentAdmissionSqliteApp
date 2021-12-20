//
//  Notice.swift
//  StudentSqlite
//
//  Created by DCS on 20/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import Foundation

class Notice {
    var id:Int = 0
    var  title:String = ""
    var date:String = ""
    var discription:String = ""
    
    init(){}
    init(id:Int,title:String,date:String,discription:String)
    {
        self.id = id
        self.title = title
        self.date = date
        self.discription = discription
    }
}
