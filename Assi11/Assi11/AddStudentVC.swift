//
//  AddStudentVC.swift
//  Assi11
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class AddStudentVC: UIViewController {

    let sql1 = SqliteHandler.shared
    var stud : Student?
    private var studArray = [Student]()
    
    public let myTextField1:UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 6
        textField.textAlignment = .left
        return textField
    }()
    public let myTextField2:UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 6
        textField.textAlignment = .left
        return textField
    }()
    public let myTextField3:UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 6
        textField.textAlignment = .left
        return textField
    }()
    //private let ClassPV = UIPickerView()
   // private let pickerData = ["FYMCA","SYMCA","TYMCA"]
    private let MyButton:UIButton={
        let button=UIButton()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(OnbtnClick), for: .touchUpInside)
        button.backgroundColor = .green
        button.layer.cornerRadius = 15
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
        view.addSubview(myTextField1)
        view.addSubview(myTextField2)
        view.addSubview(myTextField3)
        view.addSubview(MyButton)
        
        if let s1 = stud {
            myTextField1.text = s1.name
            myTextField2.text = s1.email
            myTextField3.text = s1.Class
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTextField1.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 10, width: view.width - 40, height: 40)
        myTextField2.frame = CGRect(x: 20, y:myTextField1.bottom + 10, width: view.width - 40, height: 40)
        myTextField3.frame = CGRect(x: 20, y: myTextField2.bottom + 10, width: view.width - 40, height: 40)
        MyButton.frame = CGRect(x: 20, y: myTextField3.bottom + 10, width: view.width - 40, height: 40)
    }
    
    @objc func OnbtnClick()
    {
        let name = myTextField1.text!
        let email = myTextField3.text!
        let Class = myTextField2.text!
        
        if let s1 = stud {
            let updatestud = Student(id: s1.id, name: name, email: email, pwd: s1.pwd, Class: Class)
            update(stud : updatestud)
            //print("\(updateemp.name)")
        } else{
            studArray =  SqliteHandler.shared.fetch()
            if studArray.count < 0 {
                let insertstud = Student(id: 20190101, name: name, email: email, pwd: "12345", Class: Class)
                SqliteHandler.shared.insertFirst(stud : insertstud) { [weak self] success in
                    if success {
                        print("insert First Successfully, received message at VC")
                        self?.resetFields()
                    }else {
                        print("insert First Failed, received message at VC")
                    }
                }
            } else{
                let insertstud = Student(id: 0, name: name, email: email, pwd: "12345", Class: Class)
                insert(stud : insertstud)
                //print("Insert ...")
            }
           
        }
    }
    
    private func insert(stud : Student)
    {
        SqliteHandler.shared.insert(stud : stud) { [weak self] success in
            if success {
                print("insert Successfully, received message at VC")
                self?.resetFields()
            }else {
                print("insert Failed, received message at VC")
            }
        }
    }
    
    private func update(stud : Student)
    {
        SqliteHandler.shared.update(stud : stud) {  success in
            if success {
                print("Update Successfully, received message at VC")
                self.resetFields()
            }else {
                print("Update Failed, received message at VC")
            }
        }
    }
    
    private func resetFields()
    {
        stud = nil
        myTextField1.text = ""
        myTextField2.text = ""
        myTextField3.text = ""
        
    }

}
