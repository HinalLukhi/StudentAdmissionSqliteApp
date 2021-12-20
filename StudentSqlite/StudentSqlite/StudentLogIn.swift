//
//  StudentLogIn.swift
//  Assi11
//
//  Created by DCS on 16/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class StudentLogIn: UIViewController {
    var s1:Student?
    private let myLabel:UILabel={
        let label=UILabel()
        label.text="Student LogIn"
        label.textAlignment = .center
        label.textColor = UIColor(red: 67/255, green: 117/255, blue: 191/255, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.numberOfLines = 2
        //label.backgroundColor = .white
        return label
        
    }()
    
    private let unameTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter UserName"
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 67/255, green: 117/255, blue: 191/255, alpha: 1.0).cgColor
        textField.layer.cornerRadius = 15
        return textField
    }()
    private let pwdTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.isSecureTextEntry = true
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 67/255, green: 117/255, blue: 191/255, alpha: 1.0).cgColor
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    private let LogInButton:UIButton={
        let button=UIButton()
        button.setTitle("LogIn", for: .normal)
        button.addTarget(self, action: #selector(OnLoginClicked), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 67/255, green: 117/255, blue: 191/255, alpha: 1.0)
        button.layer.cornerRadius = 20
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(myLabel)
        view.addSubview(unameTextField)
        view.addSubview(pwdTextField)
        view.addSubview(LogInButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myLabel.frame = CGRect(x: 60, y: 200, width: 250, height: 50)
        unameTextField.frame = CGRect(x: 40, y: myLabel.bottom+50, width: view.width-80, height: 40)
        pwdTextField.frame = CGRect(x: 40, y: unameTextField.bottom + 10, width: view.width-80, height: 40)
        LogInButton.frame = CGRect(x: 40, y:pwdTextField.bottom+10, width: view.width-80, height: 40)
    }
    
    
    @objc private func OnLoginClicked(){
        
        /*SqliteHandler.shared.chkLogin(for: Int32(unameTextField.text),pwd: pwdTextField.text) { success in
            if success {
                //let vc = StudentHome()
                //vc.id = Int(uid)!
                //navigationController?.pushViewController(vc, animated: true)
            }else {
                let alert = UIAlertController(title: "LOG IN", message:  "Username and Pasword is Invalid....", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                DispatchQueue.main.async {
                    self.present(alert,animated:  true)
                }
                self.unameTextField.text = ""
                self.pwdTextField.text = ""
            }
        }*/
        s1 = SqliteHandler.shared.chkLogin(for: Int(unameTextField.text!)!, for: pwdTextField.text!)
        let vc =  StudentDashboard()
        if s1?.name != "" {
            vc.stud = s1
             UserDefaults.standard.setValue(unameTextField.text, forKey: "User")
            navigationController?.pushViewController(vc, animated: true)
        }else {
            let alert = UIAlertController(title: "LOG IN", message:  "Username and Pasword is Invalid....", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            DispatchQueue.main.async {
                self.present(alert,animated:  true)
            }
            unameTextField.text = ""
            pwdTextField.text = ""
        }
       /* UserDefaults.standard.setValue(unameTextField.text, forKey: "username")
        self.dismiss(animated: true)*/
    }
    
    
}
