//
//  Test3Controller.swift
//  CustomAnimation
//
//  Created by jasnig on 16/6/24.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class Test3Controller: UIViewController {

    @IBAction func back(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func show(_ sender: AnyObject) {
        let testVc = UIViewController()
        testVc.title = "分类实现返回"
        testVc.view.backgroundColor = UIColor.red()
        show(testVc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 使用分类方法开启(关闭)全屏返回手势
        navigationController?.zj_enableFullScreenPop(isEnabled: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
