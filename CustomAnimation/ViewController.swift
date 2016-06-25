//
//  ViewController.swift
//  CustomAnimation
//
//  Created by jasnig on 16/6/22.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class TestController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "第二页"
        // Do any additional setup after loading the view, typically from a nib.

        
        let btn1 = UIButton(frame: CGRect(x: 20.0, y: 20.0, width: 200.0, height: 44.0))
        btn1.backgroundColor = UIColor.black()
        btn1.setTitle("点击或者滑动返回", for: [])
        btn1.addTarget(self, action: #selector(self.dismissAction), for: .touchUpInside)
        view.addSubview(btn1)
        
    }
    

    
    func dismissAction() {
        
        dismiss(animated: true, completion: nil)
        
    }
}

