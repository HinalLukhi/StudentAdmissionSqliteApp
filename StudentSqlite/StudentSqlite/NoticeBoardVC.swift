//
//  NoticeBoardVC.swift
//  StudentSqlite
//
//  Created by DCS on 20/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class NoticeBoardVC: UIViewController {
    
    private var noticeArray = [Notice]()
    private let myTableView = UITableView()
   
   
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
      
        noticeArray =  SqliteHandler.shared.fetchData()
        myTableView.reloadData()
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationItem.setRightBarButton(add, animated: true)
        setupTableView()
       
        view.addSubview(myTableView)
    }
    
    @objc func handleAdd(){
        //print("Gallery Called")
        let vc = AddNoticeVC()
        //navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        myTableView.frame = CGRect(x: 0, y: 100, width:view.frame.size.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
    }
    
}

extension NoticeBoardVC :UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let id = noticeArray[indexPath.row].id
        
        SqliteHandler.shared.deleteNotice(for: id) { success in
            if success {
                self.noticeArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }else{
                print("Unable to delete form VC")
            }
        }
    }
    private func setupTableView()
    {
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Filecell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Filecell", for: indexPath)
        let n1 = noticeArray[indexPath.row]
        cell.textLabel?.text = "\(n1.title) \t | \t \(n1.date) "
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click")
        let vc = AddNoticeVC()
        vc.n1 = noticeArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
