//
//  iPhone11ProViewController.swift
//  JPPictureInPictureDemo
//
//  Created by 周健平 on 2020/6/28.
//

import UIKit

class iPhone11ProViewController: JPPlayerViewController {
    
    class func videoPath() -> String {
        return Bundle.main.path(forResource: "iphone-11-pro", ofType: "mp4")!
    }
    
    private var _isDidAppear = false
    
    private let bgImgView : UIImageView = {
        let bgImgView = UIImageView()
        bgImgView.backgroundColor = .black
        return bgImgView
    }()
    
    private let iPhoneLabel : UILabel = {
        let iPhoneLabel = UILabel()
        iPhoneLabel.font = .boldSystemFont(ofSize: 40)
        iPhoneLabel.textColor = .white
        iPhoneLabel.text = "iPhone 11 Pro"
        iPhoneLabel.textAlignment = .right
        return iPhoneLabel
    }()
    
    private let subLabel : UILabel = {
        let str : String = "Pro 如其名。"
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30), NSAttributedString.Key.foregroundColor: UIColor.white]
        let attStr = NSMutableAttributedString(string: str, attributes: attributes)
        let range = (str as NSString).range(of: "Pro")
        attStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 90.0 / 255.0, green: 104.0 / 255.0, blue: 90.0 / 255.0, alpha: 1)], range: range)
        
        let subLabel = UILabel()
        subLabel.attributedText = attStr
        subLabel.textAlignment = .right
        return subLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        __setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if _isDidAppear == true {return}
        
        let bgImgViewW = jp_portraitScreenWidth_
        let bgImgViewY = self.playerView.frame.maxY - jp_scaleValue(60)
        DispatchQueue.global().async {
            guard let bgImage = UIImage(contentsOfFile: Bundle.main.path(forResource: "iphone-11-pro_0", ofType: "jpg")!) else {return}
            
            let imageWhScale = bgImage.size.height / bgImage.size.width
            let bgImgViewFrame = CGRect(x: 0,
                                        y: bgImgViewY,
                                        width: bgImgViewW,
                                        height: bgImgViewW * imageWhScale)
            
            DispatchQueue.main.async {
                self.bgImgView.frame = bgImgViewFrame
                self.bgImgView.image = bgImage
                self.__loopAnimation(true, 0)
                UIView.animate(withDuration: 7) {
                    self.bgImgView.alpha = 1
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if _isDidAppear == true {return}
        _isDidAppear = true
        
        iPhoneLabel.frame = CGRect(x: -16, y: playerView.frame.maxY + 12, width: jp_portraitScreenWidth_, height: iPhoneLabel.font.lineHeight)
        subLabel.frame = CGRect(x: -16, y: iPhoneLabel.frame.maxY + 12, width: jp_portraitScreenWidth_, height: subLabel.font.lineHeight)
        
        UIView.animate(withDuration: 3, delay: 1, options: [], animations: {
            self.iPhoneLabel.alpha = 1
        }, completion: { (finish) in
            if finish == true {
                let str : String = "iPhone 11 Pro"
                let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: self.iPhoneLabel.font!, NSAttributedString.Key.foregroundColor: self.iPhoneLabel.textColor!]
                let attStr = NSMutableAttributedString(string: str, attributes: attributes)
                let range = (str as NSString).range(of: "Pro")
                attStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 90.0 / 255.0, green: 104.0 / 255.0, blue: 90.0 / 255.0, alpha: 1)], range: range)
                
                UIView.transition(with: self.iPhoneLabel, duration: 2, options: .transitionCrossDissolve, animations: {
                    self.iPhoneLabel.attributedText = attStr
                }, completion: nil)
                
                UIView.animate(withDuration: 2, animations: {
                    self.subLabel.alpha = 1
                })
            }
        })
        
        playerView.player?.play()
        UIView.animate(withDuration: 1.0, animations: {
            self.playerView.alpha = 1
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}

// MARK:- 私有API
extension iPhone11ProViewController {
    fileprivate func __setupUI() {
        view.backgroundColor = .black
        
        videoPath = iPhone11ProViewController.videoPath()
        createPlayerView(CGRect(x: 0,
                               y: jp_navTopMargin_,
                               width: jp_portraitScreenWidth_,
                               height: jp_portraitScreenWidth_ * (9.0 / 16.0)),
                         videoURL: URL(fileURLWithPath: videoPath))
        
        bgImgView.alpha = 0
        playerView.alpha = 0
        iPhoneLabel.alpha = 0
        subLabel.alpha = 0
        
        view.addSubview(bgImgView)
        view.addSubview(playerView)
        view.addSubview(iPhoneLabel)
        view.addSubview(subLabel)
    }
    
    fileprivate func __loopAnimation(_ isIdentity: Bool, _ delay: TimeInterval) {
        let transform1 = CGAffineTransform.identity
        let transform2 = CGAffineTransform(translationX: -50, y: 50).concatenating(CGAffineTransform(scaleX: 0.87, y: 0.87))
        let fromTransform = isIdentity ? transform2 : transform1
        let toTransform = isIdentity ? transform1 : transform2
        bgImgView.transform = fromTransform
        UIView.animate(withDuration: 50, delay: delay, options: .curveLinear, animations: {
            self.bgImgView.transform = toTransform
        }, completion: { (finish) in
            if finish == true { self.__loopAnimation(!isIdentity, 3.0) }
        })
    }
}
