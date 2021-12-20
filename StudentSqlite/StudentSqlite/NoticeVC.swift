//
//  NoticeVC.swift
//  StudentSqlite
//
//  Created by DCS on 20/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class NoticeVC: UIViewController {

    var n1:Notice?
    private let myDetails:UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.text=""
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Notice"
        view.addSubview(myDetails)
        if let s : Notice = n1{
            //let id = s.id
            let title = s.title
            let date = s.date
            let discription = s.discription
            myDetails.text = "\nTitle : \(title) \nDate: \(date) \ndiscription : \(discription)"
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myDetails.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 10, width: view.width - 40, height: 100)
    }

}
