//
//  JPPlayerControlView.swift
//  JPPictureInPictureDemo
//
//  Created by 周健平 on 2020/6/28.
//

import UIKit
import AVKit

class JPPlayerControlView: UIView {
    
    let progressView : UIProgressView
    
    var progress : Float {
        set {
            progressView.progress = newValue < 0 ? 0 : (newValue > 1 ? 1 : newValue)
            let alpha : CGFloat = (newValue <= 0 || newValue >= 1) ? 0 : 1
            if progressView.alpha != alpha {
                UIView.animate(withDuration: 0.5) {
                    self.progressView.alpha = alpha
                }
            }
        }
        get {
            return progressView.progress
        }
    }
    
    let blurView : UIVisualEffectView
    
    let resumeBtn : UIButton
    
    var pipBtn : UIButton?
    
    fileprivate var _isShowResumeBtn : Bool = true
    var isShowResumeBtn : Bool {
        set {
            if _isShowResumeBtn == newValue {
                return
            }
            _isShowResumeBtn = newValue
            UIView.animate(withDuration: 0.5) {
                self.blurView.alpha = newValue ? 1 : 0
            }
        }
        get {
            return _isShowResumeBtn
        }
    }
    
    override init(frame: CGRect) {
        
        self.progressView = UIProgressView(frame: CGRect(x: 0, y: frame.height - 3, width: frame.width, height: 3))
        self.progressView.trackTintColor = .lightGray
        self.progressView.progressTintColor = .white
        self.progressView.progress = 0
        self.progressView.isUserInteractionEnabled = false
        self.progressView.alpha = 0
        
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.blurView.layer.cornerRadius = 8
        self.blurView.layer.masksToBounds = true
        
        let playIcon = UIImage(named: "find_play_icon")?.withRenderingMode(.alwaysOriginal)
        let pauseIcon = UIImage(named: "find_suspend_icon")?.withRenderingMode(.alwaysOriginal)
        self.resumeBtn = UIButton(type: .system)
        self.resumeBtn.setImage(playIcon, for: .normal)
        self.resumeBtn.setImage(playIcon, for: [.normal, .highlighted])
        self.resumeBtn.setImage(pauseIcon, for: .selected)
        self.resumeBtn.setImage(pauseIcon, for: [.selected, .highlighted])
        self.resumeBtn.tintColor = .clear
        self.resumeBtn.frame = CGRect(x: 0, y: 0, width: jp_navBarH_, height: jp_navBarH_)
        self.blurView.contentView.addSubview(self.resumeBtn)
        
        if AVPictureInPictureController.isPictureInPictureSupported() == true {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true, options: [])
            } catch {
                
            }
            
            var startImage = AVPictureInPictureController.pictureInPictureButtonStartImage
            UIGraphicsBeginImageContextWithOptions(startImage.size, false, 0)
            UIColor.white.setFill()
            UIRectFill(CGRect(origin: .zero, size: startImage.size))
            startImage.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
            startImage = UIGraphicsGetImageFromCurrentImageContext() ?? startImage
            UIGraphicsEndImageContext()
            startImage = startImage.withRenderingMode(.alwaysOriginal)
            
            var stopImage = AVPictureInPictureController.pictureInPictureButtonStopImage
            UIGraphicsBeginImageContextWithOptions(stopImage.size, false, 0)
            UIColor.white.setFill()
            UIRectFill(CGRect(origin: .zero, size: stopImage.size))
            stopImage.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
            stopImage = UIGraphicsGetImageFromCurrentImageContext() ?? stopImage
            UIGraphicsEndImageContext()
            stopImage = stopImage.withRenderingMode(.alwaysOriginal)
    
            let pipBtn = UIButton(type: .system)
            pipBtn.setImage(startImage, for: .normal)
            pipBtn.setImage(startImage, for: [.normal, .highlighted])
            pipBtn.setImage(stopImage, for: .selected)
            pipBtn.setImage(stopImage, for: [.selected, .highlighted])
            pipBtn.tintColor = .clear
            pipBtn.frame = CGRect(x: self.resumeBtn.frame.maxX, y: 0, width: jp_navBarH_, height: jp_navBarH_)
            self.blurView.contentView.addSubview(pipBtn)
            self.pipBtn = pipBtn
            
            self.blurView.frame = CGRect(x: 8, y: frame.height - jp_navBarH_ - 10, width: pipBtn.frame.maxX, height: jp_navBarH_)
            
        } else {
            self.blurView.frame = CGRect(x: 8, y: frame.height - jp_navBarH_ - 10, width: self.resumeBtn.frame.width, height: jp_navBarH_)
        }
        
        super.init(frame: frame)
        addSubview(blurView)
        addSubview(progressView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
