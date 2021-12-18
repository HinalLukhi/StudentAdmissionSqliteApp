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
                Class TEXT
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
        sqlite3_finalize(createTableStatment)
    }
    
    func insert(stud:Student , completion: @escaping ((Bool) -> Void)){
        
        let insertStatmentString = "INSERT INTO student (name,pwd,email,Class) VALUES(?,?,?,?)"
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
        
        let insertStatmentString = "INSERT INTO student (id,name,pwd,email,Class) VALUES(?,?,?,?,?)"
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
        
        let updateStatementString = "UPDATE student SET name = ?,email = ?,Class =? WHERE id = ?;"
        var updateStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK
        {
            
            
            sqlite3_bind_text(updateStatement, 1, (stud.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 1, (stud.email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 1, (stud.Class as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(stud.id))
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
    func delete(for id:Int ,completion: @escaping ((Bool) -> Void)){
        
        let deleteStatementString = "DELETE FROM student WHERE id = ?;"
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
    
    func fetch()-> [Student]{
        
        let fetchStatementString = "SELECT * FROM emp;"
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
    
    func chkLogin(for id:Int,for pwd:String) -> Student{
        print("in checklogin")
        let fetchStatementString = "SELECT * FROM student where id = ? and pwd = ?;"
        var fetchStatement:OpaquePointer? = nil
        var s1 :Student = Student()
        if sqlite3_prepare_v2(db, fetchStatementString, -1, &fetchStatement, nil) == SQLITE_OK{
            
            print("in prepare")
            sqlite3_bind_int(fetchStatement, 0, Int32(id))
            sqlite3_bind_text(fetchStatement, 1, (pwd as NSString).utf8String, -1, nil)
            
            if sqlite3_step(fetchStatement) == SQLITE_ROW {
                print("fetched row Successfully")
                
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let name = String(cString:  sqlite3_column_text(fetchStatement, 1))
                let pwd = String(cString: sqlite3_column_text(fetchStatement, 2))
                let email = String(cString: sqlite3_column_text(fetchStatement, 3))
                let Class = String(cString: sqlite3_column_text(fetchStatement, 4))
                
                s1 = Student(id: id, name: name, email: email, pwd: pwd, Class: Class)
                print("\n idddddddd: \(id)")
                //return s1
                //print("\(id) | \(name) | \(email)")
            }else{
                print("no row")
            }
            
        }else{
            print("fetch statement could not be prepared")
            
        }

        sqlite3_finalize(fetchStatement)
        return s1
       
    }
    func fetchData(for id:Int)-> [Student]{
        
        let fetchStatementString = "SELECT * FROM student;"
        var fetchStatement:OpaquePointer? = nil
        
        var emp = [Student]()
        
        //prepare Statement
        if sqlite3_prepare_v2(db, fetchStatementString, -1, &fetchStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_int(fetchStatement, 0, Int32(id))
            //Evaluate Staement
            while  sqlite3_step(fetchStatement) == SQLITE_ROW {
                print("fetched row Successfully")
                
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let name = String(cString:  sqlite3_column_text(fetchStatement, 1))
                //let age = Int(sqlite3_column_int(fetchStatement, 2))
                let email = String(cString: sqlite3_column_text(fetchStatement, 3))
                
               // emp.append(Student(id: id, name: name, email: email))
                print("\(id) | \(name) | \(email)")
            }
            
        } else{
            print("fetch statement could not be prepared")
            
        }
        
        //delete Statement
        sqlite3_finalize(fetchStatement)
        
        return emp
    }
}
