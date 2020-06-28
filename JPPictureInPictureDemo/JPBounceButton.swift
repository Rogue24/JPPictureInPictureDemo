//
//  JPBounceButton.swift
//  JPPictureInPictureDemo
//
//  Created by 周健平 on 2020/6/24.
//

import UIKit

class JPBounceButton: UIButton {
    
    private let bgView : UIView = UIView()
    private let label0 : UILabel = UILabel()
    private let label1 : UILabel = UILabel()
    private let label2 : UILabel = UILabel()
    private lazy var impactFeedbacker : UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    private var _isTouching : Bool = false
    // private(set)：读公有，写私有
    private(set) var isTouching : Bool {
        set {
            if _isTouching == newValue {return}
            _isTouching = newValue
            if newValue == true {
                label1.text = "😝"
                impactFeedbacker.prepare()
                impactFeedbacker.impactOccurred()
                let transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                let transform0 = CGAffineTransform(translationX: 0, y: -12).concatenating(transform)
                let transform2 = CGAffineTransform(translationX: 0, y: 12).concatenating(transform)
                UIView.animate(withDuration: 0.28, animations: {
                    self.bgView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
                    self.label0.transform = transform0
                    self.label1.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.label2.transform = transform2
                })
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.12) { [weak self] in
                    guard let btn = self, btn.isTouching == true else {return}
                    btn.label0.text = "Free"
                }
            } else {
                label0.text = "Tap"
                label1.text = "😛"
                let transform = CGAffineTransform.identity
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations: {
                    self.bgView.transform = transform
                    self.label0.transform = transform
                    self.label1.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    self.label2.transform = transform
                }, completion: nil)
            }
        }
        get {
            return _isTouching
        }
    }
    
    var touchUpInside : (() -> Void)?
    
    class func bounceButton() -> JPBounceButton {
        let btn = self.init(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        btn.__setupUI()
        btn.__setupAction()
        return btn
    }
    
    private func __setupUI() {
        bgView.frame = bounds
        bgView.layer.cornerRadius = 20
        bgView.layer.borderWidth = 0
        bgView.backgroundColor = .yellow
        bgView.isUserInteractionEnabled = false
        addSubview(bgView)
        
        let font = UIFont(name: "Bradley Hand", size: 27)!
        let textColor = UIColor.red
            
        label1.font = .systemFont(ofSize: 54)
        label1.frame = CGRect(x: 0, y: (150 - label1.font.lineHeight) * 0.5, width: 150, height: label1.font.lineHeight)
        label1.text = "😛"
        label1.textAlignment = .center
        label1.textColor = textColor
        addSubview(label1)
        label1.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        label0.frame = CGRect(x: 0, y: (label1.frame.origin.y - font.lineHeight - 5), width: 150, height: font.lineHeight)
        label0.text = "Tap"
        label0.textAlignment = .center
        label0.font = font
        label0.textColor = textColor
        insertSubview(label0, belowSubview: label1)
        
        label2.frame = CGRect(x: 0, y: (label1.frame.maxY + 5), width: 150, height: font.lineHeight)
        label2.text = "Me"
        label2.textAlignment = .center
        label2.font = font
        label2.textColor = textColor
        insertSubview(label2, belowSubview: label1)
    }
    
    private func __setupAction() {
        addTarget(self, action: #selector(__beginTouch), for: .touchDown)
        addTarget(self, action: #selector(__beginTouch), for: .touchDragInside)
        addTarget(self, action: #selector(__endTouch), for: .touchDragOutside)
        addTarget(self, action: #selector(__endTouch), for: .touchUpOutside)
        addTarget(self, action: #selector(__endTouch), for: .touchCancel)
        addTarget(self, action: #selector(__touchUpInside), for: .touchUpInside)
    }
    
    @objc fileprivate func __beginTouch() {
        isTouching = true
    }
    
    @objc fileprivate func __endTouch() {
        isTouching = false
    }
    
    @objc fileprivate func __touchUpInside() {
        isTouching = false
        touchUpInside?()
    }
}
