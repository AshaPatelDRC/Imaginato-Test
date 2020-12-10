//
//  HomeVC.swift
//  Imaginato
//
//  Created by Prince Sojitra on 08/12/20.
//  Copyright © 2020 Asha Patel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

var viewModel = DiaryViewModel()

class HomeVC: UIViewController {
    
    @IBOutlet weak var tblHome : UITableView!
    
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tblHome.rx.setDelegate(self).disposed(by: bag)
        
        FetchDataToUserDefaults()
        
        if let value = try? viewModel.arrDiary.value(){

            if value.count == 0{
                
                if Reachability.isConnectedToNetwork(){
                    viewModel.fetchData()
                }else{
                    showNetworkNotAvailblePopup(vc: self)
                }
            }
        }
        
        bindTableView()
        // Do any additional setup after loading the view.
    }

    private func bindTableView() {
                
        viewModel.arrDiary.bind(to: tblHome.rx.items(cellIdentifier: "HometblCell", cellType: HometblCell.self)) { (row,item,cell) in
            cell.setupData(item)
            cell.btnEdit.addTarget(self, action: #selector(self.btnEditTapped(_:)), for: .touchUpInside)
            cell.btnClose.addTarget(self, action: #selector(self.btnCloseTapped(_:)), for: .touchUpInside)
            cell.btnClose.tag = row
            cell.btnEdit.tag = row
        }.disposed(by: bag)
                
        tblHome.rx.modelSelected(Diary.self).subscribe(onNext: { item in
        }).disposed(by: bag)

    }
    
    @objc func btnEditTapped(_ sender : UIButton){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        if let value = try? viewModel.arrDiary.value()[sender.tag] {
            vc.objDiary = value
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnCloseTapped(_ sender : UIButton){
        let actions: [UIAlertController.AlertAction] = [
            .action(title: "No", style: .destructive),
            .action(title: "Yes")
        ]
        UIAlertController
            .present(in: self, title: "Alert", message: "Are you sure you want to delete?", style: .alert, actions: actions)
            .subscribe(onNext: { buttonIndex in
                print(buttonIndex)
                if buttonIndex == 1{
                    if let value = try? viewModel.arrDiary.value()[sender.tag] {
                            guard var arr = try? viewModel.arrDiary.value() else { return }
                            if let index = arr.firstIndex(where: {$0.id == value.id}){
                                arr.remove(at: index)
                            }
                            viewModel.arrDiary.onNext(Sectionfilter(arr: arr))
                            SaveDataToUserDefaults()
                    }
                }
            })
            .disposed(by: bag)
    }
}



extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


