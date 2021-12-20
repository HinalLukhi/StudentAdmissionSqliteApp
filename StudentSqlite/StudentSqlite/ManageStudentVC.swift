//
//  ManageStudentVC.swift
//  Assi11
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class ManageStudentVC: UIViewController {

    private let ClassSelect:UISegmentedControl = {
        let seg = UISegmentedControl()
        seg.insertSegment(withTitle: "All", at: 0, animated: true)
        seg.insertSegment(withTitle: "FYMCA", at: 1, animated: true)
        seg.insertSegment(withTitle: "SYMCA", at: 2, animated: true)
        seg.insertSegment(withTitle: "TYMCA", at: 3, animated: true)
        seg.selectedSegmentIndex = 0
        seg.addTarget(self, action: #selector(onSegClick), for: .valueChanged)
        return  seg
    }()
    @objc func onSegClick(){
        if ClassSelect.selectedSegmentIndex == 0 {
            studArray = SqliteHandler.shared.fetch()
            studList.reloadData()
        }else if ClassSelect.selectedSegmentIndex == 1 {
            studArray = SqliteHandler.shared.fetchClassWise(for: "FYMCA")
            studList.reloadData()
        }else if ClassSelect.selectedSegmentIndex == 2 {
            studArray = SqliteHandler.shared.fetchClassWise(for: "SYMCA")
            studList.reloadData()
        }else{
            studArray = SqliteHandler.shared.fetchClassWise(for: "TYMCA")
            studList.reloadData()
        }
    }
    
    private let studList = UITableView()
    private var studArray = [Student]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        studArray = SqliteHandler.shared.fetch()
        studList.reloadData()
    }
    override func viewDidLoad() {
        title = "Manage Student"
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(ClassSelect)
        view.addSubview(studList)
        setupTableView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ClassSelect.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 10, width: view.width - 40, height: 40)
        studList.frame = CGRect(x: 20, y: ClassSelect.bottom + 10, width: view.width - 40, height: view.bottom)
    }
}
extension ManageStudentVC: UITableViewDataSource,UITableViewDelegate{
    private func setupTableView(){
        studList.dataSource = self
        studList.delegate   = self
        studList.register(StudCellView.self, forCellReuseIdentifier: "cell")
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! StudCellView
        
        let stud = studArray[indexPath.row]
        cell.setupCell(stud: stud)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let idd = studArray[indexPath.row].id
        SqliteHandler.shared.delete(for: idd){ success in
            if success {
                self.studArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                print("Unable to Delete from VC")
            }
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddStudentVC()
        vc.stud = studArray[indexPath.row]
        vc.title = "Update"
        vc.MyButton.setTitle("Update", for: .normal)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
