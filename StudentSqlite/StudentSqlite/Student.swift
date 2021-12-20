//
//  Student.swift
//  Assi11
//
//  Created by DCS on 16/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import Foundation
class Student {
    var id:Int = 0
    var name:String = ""
    var email:String = ""
    var pwd:String = ""
    var Class:String = ""
    
    init(){}
    init(id:Int,name:String,email:String,pwd:String,Class:String)
    {
        self.id = id
        self.name = name
        self.email = email
        self.pwd = pwd
        self.Class = Class
    }
}
