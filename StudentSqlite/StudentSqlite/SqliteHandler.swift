//
//  SqliteHandler.swift
//  Assi11
//
//  Created by DCS on 16/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import Foundation
import SQLite3

class SqliteHandler {
    
    static let shared = SqliteHandler()
    let dbPath = "Studentdb.sqlite"
    var db:OpaquePointer?
    
    private init(){
        db = OpenDatabase()
        
        CreateTable()
    }
    
    private func OpenDatabase() -> OpaquePointer? {
        
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dbURL = docURL.appendingPathComponent(dbPath)
        
        var database:OpaquePointer? = nil
        if sqlite3_open(dbURL.path, &database) == SQLITE_OK {
            print("Opened Connection to database successfully...\(dbURL)")
            return database
        } else {
            print("Error Connecting to  the database")
            return nil
        }
    }
    
    private func CreateTable()
    {
        let createTableString = """
            CREATE TABLE IF NOT EXISTS student(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                pwd TEXT,
                email TEXT,
                Classs TEXT
                );
        """
        
        var createTableStatment:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatment, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatment) == SQLITE_DONE {
                print("Student Table Createed ...")
            } else {
                print("Student Table could not be Created ...")
            }
            
        }
        let createTableString1 = """
            CREATE TABLE IF NOT EXISTS notice(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT,
                date TEXT,
                discription TEXT
                );
        """
        
        var createTableStatment1:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString1, -1, &createTableStatment1, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatment1) == SQLITE_DONE {
                print("Notice Table Createed ...")
            } else {
                print("Notice Table could not be Created ...")
            }
            
        }
        
        sqlite3_finalize(createTableStatment)
         sqlite3_finalize(createTableStatment1)
    }
    
    func insert(stud:Student , completion: @escaping ((Bool) -> Void)){
        
        let insertStatmentString = "INSERT INTO student (name,pwd,email,Classs) VALUES(?,?,?,?)"
        var insertStatment:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db,insertStatmentString, -1, &insertStatment, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatment, 1, (stud.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatment, 2, (stud.pwd as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatment, 3, (stud.email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatment, 4, (stud.Class as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatment) == SQLITE_DONE {
                print("inserted row Successfully")
                completion(true)
            } else {
                print("could not insert row")
                completion(false)
            }
        } else {
            print("insert statement could not be prepared")
            completion(false)
        }
        
        sqlite3_finalize(insertStatment)
    }
    
    func insertFirst(stud:Student , completion: @escaping ((Bool) -> Void)){
        
        let insertStatmentString = "INSERT INTO student (id,name,pwd,email,Classs) VALUES(?,?,?,?,?)"
        var insertStatment:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db,insertStatmentString, -1, &insertStatment, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatment, 1, Int32(stud.id))
            sqlite3_bind_text(insertStatment, 2, (stud.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatment, 3, (stud.pwd as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatment, 4, (stud.email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatment, 5, (stud.Class as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatment) == SQLITE_DONE {
                print("inserted first row Successfully")
                completion(true)
            } else {
                print("could not insert first row")
                completion(false)
            }
        } else {
            print("insert first statement could not be prepared")
            completion(false)
        }
        
        sqlite3_finalize(insertStatment)
    }
    
    func update(stud:Student ,completion: @escaping ((Bool) -> Void)){
        
        let updateStatementString = "UPDATE student SET name = ?,email = ?,Classs =? WHERE id = ?;"
        var updateStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_text(updateStatement, 1, (stud.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (stud.email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (stud.Class as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 4, Int32(stud.id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("updated row Successfully")
                completion(true)
            } else{
                print("could not update row")
                completion(false)
            }
            
        } else{
            print("update statement could not be prepared")
            completion(false)
        }
        
        //delete Statement
        sqlite3_finalize(updateStatement)
    }
    func delete(for idd:Int ,completion: @escaping ((Bool) -> Void)){
        
        let deleteStatementString = "DELETE FROM student WHERE id = ?;"
        var deleteStatement:OpaquePointer? = nil
        
        //prepare Statement
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK
        {
            
            
            sqlite3_bind_int(deleteStatement, 1, Int32(idd))
            
            //Evaluate Staement
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("deleted row Successfully")
                completion(true)
            } else{
                print("could not delete row")
                completion(false)
            }
            
        } else{
            print("delete statement could not be prepared")
            completion(false)
        }
        
        //delete Statement
        sqlite3_finalize(deleteStatement)
    }
    
    func fetch()-> [Student]{
        
        let fetchStatementString = "SELECT * FROM student;" //change
        var fetchStatement:OpaquePointer? = nil
        
        var stud = [Student]()
        
        //prepare Statement
        if sqlite3_prepare_v2(db, fetchStatementString, -1, &fetchStatement, nil) == SQLITE_OK
        {
            //Evaluate Staement
            while  sqlite3_step(fetchStatement) == SQLITE_ROW {
                print("fetched row Successfully")
                
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let name = String(cString:  sqlite3_column_text(fetchStatement, 1))
                 let pwd = String(cString: sqlite3_column_text(fetchStatement, 2))
                let email = String(cString: sqlite3_column_text(fetchStatement, 3))
                let Class = String(cString: sqlite3_column_text(fetchStatement, 4))
                
                stud.append(Student(id: id, name: name, email: email, pwd: pwd, Class: Class))
                //print("\(id) | \(name) | \(email)")
            }
            
        } else{
            print("fetch statement could not be prepared")
            
        }
        
        //delete Statement
        sqlite3_finalize(fetchStatement)
        
        return stud
    }
    //fetch_class_wise
    func fetchClassWise(for Classs:String)-> [Student]{
        
        let fetchStatString = "SELECT * FROM student WHERE Classs =?;" //change
        var fetchStat:OpaquePointer? = nil
        
        var stud = [Student]()
        
        //prepare Statement
        if sqlite3_prepare_v2(db, fetchStatString, -1, &fetchStat, nil) == SQLITE_OK
        {
            print("in prepare \(Classs)")
            sqlite3_bind_text(fetchStat, 1, (Classs as NSString).utf8String, -1, nil)
            //Evaluate Staement
            while sqlite3_step(fetchStat) == SQLITE_ROW {
                print("fetched class wise row Successfully")
                
                let id = Int(sqlite3_column_int(fetchStat, 0))
                let name = String(cString:  sqlite3_column_text(fetchStat, 1))
                 let pwd = String(cString: sqlite3_column_text(fetchStat, 2))
                let email = String(cString: sqlite3_column_text(fetchStat, 3))
                let Class = String(cString: sqlite3_column_text(fetchStat, 4))
                
                stud.append(Student(id: id, name: name, email: email, pwd: pwd, Class: Class))
                //print("\(id) | \(name) | \(email)")
            }
            
        } else{
            print("fetch class wise statement could not be prepared")
            
        }
        
        //delete Statement
        sqlite3_finalize(fetchStat)
        
        return stud
    }
    func chkLogin(for id:Int,for pwd:String) -> Student{
        print("in checklogin")
        let fetchStatementString = "SELECT * FROM student where id = ? and pwd = ?;"
        var fetchStatement:OpaquePointer? = nil
        var s1 :Student = Student()
        if sqlite3_prepare_v2(db, fetchStatementString, -1, &fetchStatement, nil) == SQLITE_OK{
            
            print("in prepare")
            sqlite3_bind_int(fetchStatement, 1, Int32(id))
            sqlite3_bind_text(fetchStatement, 2, (pwd as NSString).utf8String, -1, nil)
            
            while sqlite3_step(fetchStatement) == SQLITE_ROW {
                print("fetched row Successfully")
                
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let name = String(cString:  sqlite3_column_text(fetchStatement, 1))
                let pwd = String(cString: sqlite3_column_text(fetchStatement, 2))
                let email = String(cString: sqlite3_column_text(fetchStatement, 3))
                let Class = String(cString: sqlite3_column_text(fetchStatement, 4))
                
                s1 = Student(id: id, name: name, email: email, pwd: pwd, Class: Class)
              
                //return s1
                print("from helper:  \(id) | \(name) ")
            }
        }else{
            print("fetch statement could not be prepared")
            
        }
        sqlite3_finalize(fetchStatement)
        return s1
       
    }
    
    func fetchStud(for id:Int) -> Student{
        print("in checklogin")
        let fetchStatementString = "SELECT * FROM student where id = ?;"
        var fetchStatement:OpaquePointer? = nil
        var s1 :Student = Student()
        if sqlite3_prepare_v2(db, fetchStatementString, -1, &fetchStatement, nil) == SQLITE_OK{
            
            print("in prepare")
            sqlite3_bind_int(fetchStatement, 1, Int32(id))
            
            while sqlite3_step(fetchStatement) == SQLITE_ROW {
                print("fetched row Successfully")
                
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let name = String(cString:  sqlite3_column_text(fetchStatement, 1))
                let pwd = String(cString: sqlite3_column_text(fetchStatement, 2))
                let email = String(cString: sqlite3_column_text(fetchStatement, 3))
                let Class = String(cString: sqlite3_column_text(fetchStatement, 4))
                
                s1 = Student(id: id, name: name, email: email, pwd: pwd, Class: Class)
                
                //return s1
                print("from helper:  \(id) | \(name) ")
            }
        }else{
            print("fetch statement could not be prepared")
            
        }
        sqlite3_finalize(fetchStatement)
        return s1
        
    }
    
    //chnage password
    func updatepwd(pwd:String ,id:Int,completion: @escaping ((Bool) -> Void)){
        
        let updateStatementString = "UPDATE student SET pwd = ? WHERE id = ?;"
        var updateStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK
        {
            
            sqlite3_bind_text(updateStatement, 1, (pwd as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("updated pwd Successfully")
                completion(true)
            } else{
                print("could not update pwd")
                completion(false)
            }
            
        } else{
            print("pwd update statement could not be prepared")
            completion(false)
        }
        
        sqlite3_finalize(updateStatement)
    }
    
    
    func insertNotice(n1: Notice , completion: @escaping ((Bool) -> Void)){
        
        let insertStatmentString = "INSERT INTO notice(title,date,discription) VALUES(?,?,?);"
        var insertStatment:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db,insertStatmentString, -1, &insertStatment, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatment, 1, (n1.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatment, 2, (n1.date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatment, 3, (n1.discription as NSString).utf8String, -1, nil)
        
            
            if sqlite3_step(insertStatment) == SQLITE_DONE {
                print("inserted row Successfully")
                completion(true)
            } else {
                print("could not insert row")
                completion(false)
            }
        } else {
            print("insert statement could not be prepared")
            completion(false)
        }
        
        sqlite3_finalize(insertStatment)
    }
    
    
    func updateNotice(n1: Notice , completion: @escaping ((Bool) -> Void)){
        
        let updateStatmentString = "update notice set title = ? ,date = ?,discription = ? where Id=?"
        var updateStatment:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db,updateStatmentString, -1, &updateStatment, nil) == SQLITE_OK {
            
            sqlite3_bind_text(updateStatment, 1, (n1.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatment, 2, (n1.date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatment, 3, (n1.discription as NSString).utf8String, -1, nil)
             sqlite3_bind_int(updateStatment, 4, Int32(n1.id))
            
            if sqlite3_step(updateStatment) == SQLITE_DONE {
                print("updated row Successfully")
                completion(true)
            } else {
                print("could not update row")
                completion(false)
            }
        } else {
            print("update statement could not be prepared")
            completion(false)
        }
        
        sqlite3_finalize(updateStatment)
    }
    
    func deleteNotice(for id:Int ,completion: @escaping ((Bool) -> Void)){
        
        let deleteStatementString = "DELETE FROM notice WHERE id = ?;"
        var deleteStatement:OpaquePointer? = nil
        
        //prepare Statement
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK
        {
            
            
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            //Evaluate Staement
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("deleted row Successfully")
                completion(true)
            } else{
                print("could not delete row")
                completion(false)
            }
            
        } else{
            print("delete statement could not be prepared")
            completion(false)
        }
        
        //delete Statement
        sqlite3_finalize(deleteStatement)
    }
    
    func fetchData()-> [Notice]{
        
        let fetchStatementString = "SELECT * FROM notice;"
        var fetchStatement:OpaquePointer? = nil
        
        var n1 = [Notice]()
        
        //prepare Statement
        if sqlite3_prepare_v2(db, fetchStatementString, -1, &fetchStatement, nil) == SQLITE_OK
        {
          //  sqlite3_bind_int(fetchStatement, 0, Int32(id))
            //Evaluate Staement
            while  sqlite3_step(fetchStatement) == SQLITE_ROW {
                print("fetched row Successfully")
                
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let title = String(cString:  sqlite3_column_text(fetchStatement, 1))
                //let age = Int(sqlite3_column_int(fetchStatement, 2))
                let date = String(cString: sqlite3_column_text(fetchStatement, 2))
                let discription = String(cString: sqlite3_column_text(fetchStatement, 3))
                
               n1.append(Notice(id: id, title: title, date: date, discription: discription))
                
            }
            
        } else{
            print("fetch statement could not be prepared")
            
        }
        
        //delete Statement
        sqlite3_finalize(fetchStatement)
        
        return n1
    }
    
}
