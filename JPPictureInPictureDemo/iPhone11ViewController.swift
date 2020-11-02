//
//  iPhone11ViewController.swift
//  JPPictureInPictureDemo
//
//  Created by 周健平 on 2020/6/28.
//

import UIKit

class iPhone11ViewController: PlayerViewController {

    class func videoPath() -> String { Bundle.main.path(forResource: "iphone-11", ofType: "mp4")! }
    
    fileprivate let shadowLayer : CALayer = CALayer()
    
    fileprivate var imagePaths : [UIImage] = []
    fileprivate var _imageIndex : Int = 0
    
    private let bgImgView : UIImageView = {
        let bgImgView = UIImageView(frame: UIScreen.main.bounds)
        bgImgView.contentMode = .scaleAspectFill
        bgImgView.backgroundColor = .white
        return bgImgView
    }()
    
    private let iPhoneLabel : UILabel = {
        let iPhoneLabel = UILabel()
        
        let str : String = "iPhone 11"
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 3
        shadow.shadowColor = UIColor(white: 0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        let attributes : [NSAttributedString.Key : Any] =
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40),
             NSAttributedString.Key.foregroundColor: UIColor.systemPink,
             NSAttributedString.Key.shadow: shadow]
        let attStr = NSMutableAttributedString(string: str, attributes: attributes)
        
        let color0 = UIColor(red: 198.0 / 255.0, green: 194.0 / 255.0, blue: 211.0 / 255.0, alpha: 1)
        let color1 = UIColor(red: 158.0 / 255.0, green: 219.0 / 255.0, blue: 194.0 / 255.0, alpha: 1)
        let color2 = UIColor(red: 253.0 / 255.0, green: 226.0 / 255.0, blue: 109.0 / 255.0, alpha: 1)
        let color3 = UIColor(red: 248.0 / 255.0, green: 244.0 / 255.0, blue: 235.0 / 255.0, alpha: 1)
        let color4 = UIColor(red: 22.0 / 255.0, green: 25.0 / 255.0, blue: 25.0 / 255.0, alpha: 1)
        let color5 = UIColor(red: 169.0 / 255.0, green: 0, blue: 36.0 / 255.0, alpha: 1)
        attStr.addAttributes([NSAttributedString.Key.foregroundColor: color0], range: NSRange(location: 0, length: 1))
        attStr.addAttributes([NSAttributedString.Key.foregroundColor: color1], range: NSRange(location: 1, length: 1))
        attStr.addAttributes([NSAttributedString.Key.foregroundColor: color2], range: NSRange(location: 2, length: 1))
        attStr.addAttributes([NSAttributedString.Key.foregroundColor: color3], range: NSRange(location: 3, length: 1))
        attStr.addAttributes([NSAttributedString.Key.foregroundColor: color4], range: NSRange(location: 4, length: 1))
        attStr.addAttributes([NSAttributedString.Key.foregroundColor: color5], range: NSRange(location: 5, length: 1))
        
        iPhoneLabel.attributedText = attStr
        iPhoneLabel.textAlignment = .center
        iPhoneLabel.sizeToFit()
        return iPhoneLabel
    }()
    
    private let subLabel : UILabel = {
        let subLabel = UILabel()
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 3
        shadow.shadowColor = UIColor(white: 0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        let attributes : [NSAttributedString.Key : Any] =
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),
             NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.shadow: shadow]
        let attStr = NSMutableAttributedString(string: "一切都刚刚好。", attributes: attributes)
        subLabel.attributedText = attStr
        subLabel.textAlignment = .center
        subLabel.sizeToFit()
        return subLabel
    }()
    
    private var _isDidAppear = false
    
    fileprivate var workItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        __setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if _isDidAppear { return }
        
        DispatchQueue.global().async {
            let image0 : UIImage = UIImage(contentsOfFile: Bundle.main.path(forResource: "iphone-11_0", ofType: "jpg")!)!
            let image1 : UIImage = UIImage(contentsOfFile: Bundle.main.path(forResource: "iphone-11_1", ofType: "jpg")!)!
            let image2 : UIImage = UIImage(contentsOfFile: Bundle.main.path(forResource: "iphone-11_2", ofType: "jpg")!)!
            
            self.imagePaths.append(image0)
            self.imagePaths.append(image1)
            self.imagePaths.append(image2)
            
            DispatchQueue.main.async { [weak self] in
                self?.__loopAnimation(delay: 0)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if _isDidAppear { return }
        _isDidAppear = true
        
        UIView.animate(withDuration: 1, delay: 1, options: [], animations: {
            self.iPhoneLabel.alpha = 1
        }, completion: { (finish) in
            if finish {
                UIView.animate(withDuration: 1, animations: {
                    self.subLabel.alpha = 1
                })
            }
        })
        
        playerView.player?.play()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
    
    deinit { workItem?.cancel() }
}

// MARK:- 私有API
extension iPhone11ViewController {
    fileprivate func __setupUI() {
        view.backgroundColor = .white
        
        let x : CGFloat = 16.0
        let w : CGFloat = PortraitScreenWidth - 2 * x
        let h : CGFloat = w * (9.0 / 16.0)
        let y : CGFloat = PortraitScreenHeight * 0.3
        videoPath = iPhone11ViewController.videoPath()
        createPlayerView(CGRect(x: x, y: y, width: w, height: h),
                         videoURL: URL(fileURLWithPath: videoPath))
        playerView.layer.cornerRadius = 10
        playerView.layer.masksToBounds = true
        
        shadowLayer.shadowPath = UIBezierPath(roundedRect: playerView.frame, cornerRadius: playerView.layer.cornerRadius).cgPath
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 10
        shadowLayer.shadowOffset = CGSize(width: 0, height: 5)
        
        iPhoneLabel.frame.origin = CGPoint(x: (PortraitScreenWidth - iPhoneLabel.frame.width) * 0.5, y: NavTopMargin + 15)
        iPhoneLabel.alpha = 0
        
        subLabel.frame.origin = CGPoint(x: (PortraitScreenWidth - subLabel.frame.width) * 0.5, y: iPhoneLabel.frame.maxY + 15)
        subLabel.alpha = 0
        
        view.addSubview(bgImgView)
        view.layer.addSublayer(shadowLayer)
        view.addSubview(playerView)
        view.addSubview(iPhoneLabel)
        view.addSubview(subLabel)
    }
    
    fileprivate func __loopAnimation(delay: TimeInterval) {
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            if self._imageIndex >= self.imagePaths.count {
                self._imageIndex = 0
            }
            let bgImage = self.imagePaths[self._imageIndex]
            UIView.transition(with: self.bgImgView, duration: 3.0, options: .transitionCrossDissolve, animations: {
                self.bgImgView.image = bgImage
            }) { finish in
                if finish {
                    self._imageIndex += 1
                    self.__loopAnimation(delay: 10.0)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: workItem)
        self.workItem = workItem
    }
}

