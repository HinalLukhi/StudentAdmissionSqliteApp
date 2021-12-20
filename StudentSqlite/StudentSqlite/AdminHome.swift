//
//  AdminHome.swift
//  Assi11
//
//  Created by DCS on 17/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class AdminHome: UIViewController {

    private let menuTableView = UITableView()
    
    private let Menu = ["Home","Add Student","Manage Student","Notice"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Admin"
        let add = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(LogOut))
        
        navigationItem.setRightBarButton(add, animated: true)
        view.addSubview(menuTableView)
        setTableView()
    }
    
    func setTableView(){
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(TblCell.self, forCellReuseIdentifier: "Cell")
    }
    @objc func LogOut(){
        UserDefaults.standard.setValue(nil, forKey: "AdminName")
        checkAuth()
    }
    override func viewWillLayoutSubviews() {
        menuTableView.frame = CGRect(x: 0,
                                     y: view.safeAreaInsets.top,
                                     width: view.frame.size.width,
                                     height: view.frame.size.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        checkAuth()
    }
    private func checkAuth()
    {
        if let uname = UserDefaults.standard.string(forKey: "AdminName"){
            print(uname)
            // usernameLabel.text = "Welcome, \(uname)"
        }else{
            let vc = AdminLogIn()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            nav.setNavigationBarHidden(true, animated: false)
            present(nav,animated: true)
        }
    }
    

}
extension AdminHome : UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item)
    }
}
extension AdminHome : UITableViewDataSource,UITableViewDelegate{
    
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
            /*let vc = AdminHome()
            navigationController?.pushViewController(vc, animated: true)*/
        }
        if Menu[indexPath.row] == "Add Student" {
            let vc = AddStudentVC()
            vc.title = "Add Student"
            navigationController?.pushViewController(vc, animated: true)
        }
        if Menu[indexPath.row] == "Manage Student" {
            let vc = ManageStudentVC()
            navigationController?.pushViewController(vc, animated: true)
        }
        if Menu[indexPath.row] == "Notice" {
            let vc = NoticeBoardVC()
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
