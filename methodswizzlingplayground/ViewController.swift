//
//  ViewController.swift
//  methodswizzlingplayground
//
//  Created by 田中 達也 on 2016/09/08.
//  Copyright © 2016年 tattn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
    }

    @IBAction func tapButton(_ sender: UIButton) {
        print("tapButton")

        let newTapButton = "newTapButton:"

        MethodSwizzling.replaceInstanceMethod(target: type(of: self),
                                              from: "tapButton:",
                                              to: newTapButton)

    }

    func newTapButton(_ sender: UIButton) {
        print("NEW!!!! tapButton")
    }

}

extension UIViewController {
    override open class func initialize() {

        // サブクラスからの呼び出しは無視
        guard self === UIViewController.self else { return }

        struct Static {
            static var once = true
        }

        if Static.once {
            Static.once = false
            MethodSwizzling.replaceInstanceMethod(target: self,
                                                  from: "viewDidLoad",
                                                  to: "log_viewDidLoad")
        }
    }

    func log_viewDidLoad() {
        self.log_viewDidLoad() // 元のviewDidLoadの呼び出し

        print("log_viewDidLoad")
    }
}

