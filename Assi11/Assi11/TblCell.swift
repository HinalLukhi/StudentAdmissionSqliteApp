//
//  TblCell.swift
//  Assi11
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class TblCell: UITableViewCell {

    private let imgview:UIImageView={
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        //img.layer.cornerRadius = 10
        
        return img
    }()
    
    private let myLabel:UILabel={
        let label=UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
        
    }()
    
    func setupCityCellWith(title name: String){
        contentView.addSubview(imgview)
        contentView.addSubview(myLabel)
        
        imgview.frame = CGRect(x: 20, y: 15, width: 25, height: 25)
        myLabel.frame = CGRect(x: imgview.right+20, y: 10, width: 200, height: 40)
        
        imgview.image = UIImage(named: name)
        myLabel.text = name
        
    }
    

}
