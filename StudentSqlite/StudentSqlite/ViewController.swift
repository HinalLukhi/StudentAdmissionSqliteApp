//
//  ViewController.swift
//  Assi11
//
//  Created by DCS on 15/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let AdminLogInBtn:UIButton={
        let button=UIButton()
        button.setTitle("Admin", for: .normal)
        button.addTarget(self, action: #selector(adminLogin), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 67/255, green: 117/255, blue: 191/255, alpha: 1.0)
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let StudentLogInBtn:UIButton={
        let button=UIButton()
        button.setTitle("Student", for: .normal)
        button.addTarget(self, action: #selector(studentLogin), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 67/255, green: 117/255, blue: 191/255, alpha: 1.0)
        button.layer.cornerRadius = 20
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(AdminLogInBtn)
        view.addSubview(StudentLogInBtn)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
     
       AdminLogInBtn.frame = CGRect(x: 20, y: 200, width: view.width-50, height: 50)
        StudentLogInBtn.frame = CGRect(x: 20, y: AdminLogInBtn.bottom+10, width: view.width-50, height: 50)
        
    
    }
        
    @objc func adminLogin()
    {
        let vc = AdminHome()
        //navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func studentLogin()
    {
        let vc = StudentDashboard()
        //navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }
}

