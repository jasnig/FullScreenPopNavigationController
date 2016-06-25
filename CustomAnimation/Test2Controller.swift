//
//  Test2Controller.swift
//  CustomAnimation
//
//  Created by jasnig on 16/6/24.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class Test2Controller: UIViewController {
    @IBAction func back(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func show(_ sender: AnyObject) {
        let testVc = TestCancelPopController()
        testVc.view.backgroundColor = UIColor.red()
        show(testVc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

class TestCancelPopController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "自定义实现返回"
        let btn = UIButton(frame: CGRect(x: 100.0, y: 100.0, width: 180.0, height: 100.0))
        btn.backgroundColor = UIColor.black()
        btn.setTitle("取消全屏返回手势", for: [])
        btn.addTarget(self, action: #selector(self.btnOnClick), for: .touchUpInside)
        view.addSubview(btn)
    }
    func btnOnClick() {
        // 如果是使用分类navigationController?.zj_enableFullScreenPop(isEnabled: false)

        (navigationController as? CustomNavigationController)?.enabledFullScreenPop(isEnabled: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
