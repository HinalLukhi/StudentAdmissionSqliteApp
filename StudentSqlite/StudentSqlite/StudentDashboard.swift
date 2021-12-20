//
//  StudentDashboard.swift
//  Assi11
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class StudentDashboard: UIViewController {
    var stud:Student?
    
    private let MenuView = UITableView()
    
    private let Menu = ["Home","Change password","View details","Notice"]
    
    func setTableView(){
        MenuView.dataSource = self
        MenuView.delegate = self
        MenuView.register(TblCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        title = stud?.name
        let add = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(LogOut))
        
        navigationItem.setRightBarButton(add, animated: true)
        view.addSubview(MenuView)
        
        setTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        checkAuth()
         title = stud?.name
    }
    private func checkAuth()
    {
        if let uname = UserDefaults.standard.string(forKey: "User"){
            print(uname)
            stud = SqliteHandler.shared.fetchStud(for: Int(uname)!)
            // usernameLabel.text = "Welcome, \(uname)"
        }else{
            let vc = StudentLogIn()
            let nav = UINavigationController(rootViewController: vc)
            //nav.modalPresentationStyle = .fullScreen
            //nav.setNavigationBarHidden(true, animated: false)
            present(nav,animated: true)
        }
    }
    
    @objc func LogOut(){
        UserDefaults.standard.setValue(nil, forKey: "User")
        checkAuth()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        MenuView.frame = CGRect(x: 0,
                                     y: view.safeAreaInsets.top,
                                     width: view.frame.size.width,
                                     height: view.frame.size.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
    }
}
extension StudentDashboard : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0{
            return Menu.count
        }
        else{
            return Menu.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TblCell
        cell.setupCellWith(title: Menu[indexPath.row])
            return cell
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Menu[indexPath.row] == "Home" {
           // let vc = StudentDashboard()
            //navigationController?.pushViewController(vc, animated: true)
        }
        if Menu[indexPath.row] == "Change password" {
            let vc = ChangePassword()
            vc.stud = stud
            navigationController?.pushViewController(vc, animated: true)
        }
        if Menu[indexPath.row] == "View details" {
            let vc = ViewDetails()
            vc.stud = stud
            navigationController?.pushViewController(vc, animated: true)
        }
        if Menu[indexPath.row] == "Notice" {
            let vc = ViewNoticeVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Menu"
    }
}
