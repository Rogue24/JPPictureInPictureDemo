//
//  FunButton.swift
//  JPPictureInPictureDemo
//
//  Created by 周健平 on 2020/6/24.
//

import UIKit

class FunButton: UIButton {
    private let bgView: UIView = UIView()
    private let label0: UILabel = UILabel()
    private let label1: UILabel = UILabel()
    private let label2: UILabel = UILabel()
    private lazy var impactFeedbacker: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    private var _isTouching: Bool = false
    // private(set)：读公有，写私有
    private(set) var isTouching: Bool {
        set {
            if _isTouching == newValue { return }
            _isTouching = newValue
            if newValue {
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
                    guard let self = self, self.isTouching else {return}
                    self.label0.text = "Free"
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
        get { _isTouching }
    }
    
    var touchUpInside: (() -> ())?
    
    class func build(_ touchUpInside: (() -> Void)? = nil) -> FunButton {
        let btn = self.init(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        btn._setupUI()
        btn._setupAction()
        btn.touchUpInside = touchUpInside
        return btn
    }
}

private extension FunButton {
    func _setupUI() {
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
    
    func _setupAction() {
        addTarget(self, action: #selector(_beginTouch), for: .touchDown)
        addTarget(self, action: #selector(_beginTouch), for: .touchDragInside)
        addTarget(self, action: #selector(_endTouch), for: .touchDragOutside)
        addTarget(self, action: #selector(_endTouch), for: .touchUpOutside)
        addTarget(self, action: #selector(_endTouch), for: .touchCancel)
        addTarget(self, action: #selector(_touchUpInside), for: .touchUpInside)
    }
    
    @objc func _beginTouch() {
        isTouching = true
    }
    
    @objc func _endTouch() {
        isTouching = false
    }
    
    @objc func _touchUpInside() {
        isTouching = false
        touchUpInside?()
    }
}
