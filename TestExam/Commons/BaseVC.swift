//
//  BaseVC.swift
//  TestExam
//
//  Created by Ngo Bao Ngoc on 28/03/2021.
//

import UIKit

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        bindData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func bindData() {}
    func initUI() {}
    func initData() {}
    func bindUI() {}
    
    deinit {
        print("deinit gì cũng được")
    }

    func dismissOrPop() {
        if self.navigationController?.topViewController == self {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}


