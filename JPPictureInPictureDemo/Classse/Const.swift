//
//  Const.swift
//  Neves_Example
//
//  Created by 周健平 on 2020/10/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

let ScreenScale: CGFloat = UIScreen.main.scale

let PortraitScreenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
let PortraitScreenHeight: CGFloat = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
let PortraitScreenSize: CGSize = CGSize(width: PortraitScreenWidth, height: PortraitScreenHeight)
let PortraitScreenBounds: CGRect = CGRect(origin: .zero, size: PortraitScreenSize)

let LandscapeScreenWidth: CGFloat = PortraitScreenHeight
let LandscapeScreenHeight: CGFloat = PortraitScreenWidth
let LandscapeScreenSize: CGSize = CGSize(width: LandscapeScreenWidth, height: LandscapeScreenHeight)
let LandscapeScreenBounds: CGRect = CGRect(origin: .zero, size: LandscapeScreenSize)

let IsBangsScreen: Bool = PortraitScreenHeight > 736.0

let BaseTabBarH: CGFloat = 49.0
let TabBarH: CGFloat = IsBangsScreen ? 83.0 : BaseTabBarH
let DiffTabBarH: CGFloat = TabBarH - BaseTabBarH

let BaseStatusBarH: CGFloat = 20.0
let StatusBarH: CGFloat = IsBangsScreen ? 44.0 : BaseStatusBarH
let DiffStatusBarH: CGFloat = StatusBarH - BaseStatusBarH

let NavBarH: CGFloat = 44.0
let NavTopMargin: CGFloat = StatusBarH + NavBarH

let BasisWScale: CGFloat = PortraitScreenWidth / 375.0
let BasisHScale: CGFloat = PortraitScreenHeight / 667.0

let SeparateLineThick: CGFloat = ScreenScale > 2 ? 0.333 : 0.5;

let AspectRatio_16_9: CGFloat = 16.0 / 9.0
let AspectRatio_9_16: CGFloat = 9.0 / 16.0

func ScaleValue(_ value: CGFloat) -> CGFloat {
    value * BasisWScale
}
