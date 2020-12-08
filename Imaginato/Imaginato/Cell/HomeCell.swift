//
//  HomeCell.swift
//  Imaginato
//
//  Created by Prince Sojitra on 08/12/20.
//  Copyright © 2020 Asha Patel. All rights reserved.
//

import Foundation
import UIKit

class HometblCell : UITableViewCell{
    
    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var btnEdit : UIButton!
    @IBOutlet weak var btnClose : UIButton!
    @IBOutlet weak var lblCircle : UILabel!
    @IBOutlet weak var lblSaparator : UILabel!
    @IBOutlet weak var lblHeaderTitle : UILabel!
    @IBOutlet weak var headerHieghtConstraint : NSLayoutConstraint!
    @IBOutlet weak var imgIcon : UIImageView!

    override func awakeFromNib() {
        bgView.addShadow()
    }
    
    func setupData(_ diary : Diary?){
        if let objdiary = diary{
            lblTitle.text = objdiary.title
            lblHeaderTitle.text = objdiary.date
            lblDesc.text = objdiary.content
            lblTime.text = "\(((objdiary.date).toDate() ?? Date()).timeAgo()) ago"
            lblHeaderTitle.text = objdiary.date.toDateString()
            headerHieghtConstraint.constant = (objdiary.isShow ?? false) ? 50 : 0
            imgIcon.isHidden = (objdiary.isShow ?? false) ? false : true
            lblHeaderTitle.isHidden = (objdiary.isShow ?? false) ? false : true
        }
    }

}

