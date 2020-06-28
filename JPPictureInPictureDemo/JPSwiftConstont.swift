//
//  UIView+JPExtension.swift
//  JPFloatingWindow
//
//  Created by 周健平 on 2020/2/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

let jp_screenScale_ : CGFloat = UIScreen.main.scale

let jp_portraitScreenWidth_ : CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
let jp_portraitScreenHeight_ : CGFloat = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
let jp_portraitScreenSize_ : CGSize = CGSize(width: jp_portraitScreenWidth_, height: jp_portraitScreenHeight_)
let jp_portraitScreenBounds_ : CGRect = CGRect(x: 0, y: 0, width: jp_portraitScreenWidth_, height: jp_portraitScreenHeight_)

let jp_isIphoneX_ : Bool = jp_portraitScreenHeight_ > 736.0

let jp_baseTabBarH_ : CGFloat = 49.0
let jp_tabBarH_ : CGFloat = jp_isIphoneX_ ? 83.0 : jp_baseTabBarH_
let jp_diffTabBarH_ : CGFloat = jp_tabBarH_ - jp_baseTabBarH_

let jp_baseStatusBarH_ : CGFloat = 20.0
let jp_statusBarH_ : CGFloat = jp_isIphoneX_ ? 44.0 : jp_baseStatusBarH_
let jp_diffStatusBarH_ : CGFloat = jp_statusBarH_ - jp_baseStatusBarH_

let jp_navBarH_ : CGFloat = 44.0
let jp_navTopMargin_ : CGFloat = jp_statusBarH_ + jp_navBarH_

let jp_scale_ : CGFloat = jp_portraitScreenWidth_ / 375.0
public func jp_scaleValue(_ value: CGFloat) -> CGFloat {
    (value) * jp_scale_
}
public func jp_halfValue(_ value1: CGFloat, _ value2: CGFloat) -> CGFloat {
    ((value1) - (value2)) * 0.5
}
