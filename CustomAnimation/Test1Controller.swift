//
//  Test1Controller.swift
//  CustomAnimation
//
//  Created by jasnig on 16/6/24.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class Test1Controller: UIViewController {

    let deletage = CustomDelegate()
    
    @IBAction func present(_ sender: UIButton) {
        let testVc = TestController()
        testVc.view.backgroundColor = UIColor.red()
        testVc.modalPresentationStyle = .fullScreen
        // 因为transitioningDelegate是weak 所以这里不能使用局部变量 CustomDelegate()
//        testVc.transitioningDelegate = CustomDelegate()

        testVc.transitioningDelegate = deletage
        present(testVc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
