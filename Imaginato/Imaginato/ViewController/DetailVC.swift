//
//  DetailVC.swift
//  Imaginato
//
//  Created by Prince Sojitra on 08/12/20.
//  Copyright © 2020 Asha Patel. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var txtTitle : UITextField!
    @IBOutlet weak var txtDesc : UITextView!
    @IBOutlet weak var btnSave : UIButton!
    
    var objDiary : Diary?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupdate()
        // Do any additional setup after loading the view.
    }
    
    func setupdate(){
        txtTitle.text = objDiary?.title
        txtDesc.text = objDiary?.content
    }
    
    @IBAction func btnSaveClicked(_ sender : UIButton){
        self.view.endEditing(true)
        objDiary?.content = txtDesc.text ?? ""
        objDiary?.title = txtTitle.text ?? ""
        guard var arr = try? viewModel.arrDiary.value() else { return }
        if let index = arr.firstIndex(where: {$0.id == objDiary?.id}){
            arr[index] = objDiary!
        }
        viewModel.arrDiary.onNext(Sectionfilter(arr: arr))
        SaveDataToUserDefaults()
        self.navigationController?.popViewController(animated: true)
    }
}
