//
//  MethodSwizzling.swift
//  methodswizzlingplayground
//
//  Created by 田中 達也 on 2016/09/08.
//  Copyright © 2016年 tattn. All rights reserved.
//

import Foundation

// see: https://developer.apple.com/reference/objectivec/1657527-objective_c_runtime

struct MethodSwizzling {

    static func replaceInstanceMethod(target: AnyClass,
                                      from: String,
                                      to: String) {
        replaceInstanceMethod(target: target,
                              from: Selector(from),
                              to: Selector(to))
    }

    static func replaceInstanceMethod(target: AnyClass,
                                      from: Selector,
                                      to: Selector) {

        let fromMethod = class_getInstanceMethod(target, from)
        let toMethod   = class_getInstanceMethod(target, to)

        // 元のメソッドが存在していなければ追加
        if class_addMethod(target, from, method_getImplementation(toMethod), method_getTypeEncoding(toMethod)) {
            // 元のメソッドをSwizzledメソッドに置換
            class_replaceMethod(target, to, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod))
        } else {
            // 元のメソッドが存在していたら、Swizzledメソッドと入れ替え 
            method_exchangeImplementations(fromMethod, toMethod)
        }
    }
}
