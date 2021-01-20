//
//  PlayerView.swift
//  JPPictureInPictureDemo
//
//  Created by 周健平 on 2020/6/25.
//

import UIKit
import AVKit

class PlayerView: UIView {
    
    var playerLayer: AVPlayerLayer = AVPlayerLayer()
    let controlView: PlayerControlView
    
    var urlAsset: AVURLAsset?
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    
    fileprivate var timeObserver: Any?
    
    fileprivate weak var pipCtr: AVPictureInPictureController?
    
    fileprivate var _isPlayDone: Bool = false
    
    fileprivate var _timer: Timer?
    
    override init(frame: CGRect) {
        self.controlView = PlayerControlView(frame: CGRect(origin: .zero, size: frame.size))
        super.init(frame: frame)
        _setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        _removeTimer()
        
        if let player = player {
            NotificationCenter.default.removeObserver(self)
            
            player.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate))
            
            if let timeObserver = timeObserver {
                player.removeTimeObserver(timeObserver)
                self.timeObserver = nil
            }
            
            player.replaceCurrentItem(with: nil)
        }
        
        if let pipCtr = pipCtr {
            pipCtr.removeObserver(self, forKeyPath: #keyPath(AVPictureInPictureController.isPictureInPicturePossible))
            pipCtr.removeObserver(self, forKeyPath: #keyPath(AVPictureInPictureController.isPictureInPictureActive))
        }
    }
}

// MARK:- API
extension PlayerView {
    func setupVideoURL(_ videoURL: URL, pipCtr: AVPictureInPictureController?) {
        let asset = AVURLAsset(url: videoURL)
        urlAsset = asset
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        if let player = player {
            playerLayer.player = player
            
            timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main) { [weak self] (time) in
                guard let currentItem = self?.playerItem else {return}
                let loadedRanges = currentItem.seekableTimeRanges
                if loadedRanges.count > 0 && currentItem.duration.timescale != 0 {
                    let progress = CMTimeGetSeconds(time) / CMTimeGetSeconds(currentItem.duration)
                    self?.controlView.progress = Float(progress)
                } else {
                    self?.controlView.progress = 0
                }
            }
            
            player.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: .new, context: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(_playDidEnd), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: playerItem)
        }
        
        self.pipCtr = pipCtr
        if let pipCtr = pipCtr {
            pipCtr.addObserver(self, forKeyPath: #keyPath(AVPictureInPictureController.isPictureInPicturePossible), options: .new, context: nil)
            pipCtr.addObserver(self, forKeyPath: #keyPath(AVPictureInPictureController.isPictureInPictureActive), options: .new, context: nil)
        }
    }
}

// MARK:- 私有API
private extension PlayerView {
    func _setupUI() {
        clipsToBounds = true
        backgroundColor = .black
        
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer)
        
        controlView.resumeBtn.addTarget(self, action: #selector(_resumeOrPause), for: .touchUpInside)
        controlView.pipBtn?.addTarget(self, action: #selector(_togglePictureInPicture), for: .touchUpInside)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(_tap))
        tapGR.delegate = self
        controlView.addGestureRecognizer(tapGR)
        addSubview(controlView)
    }
}

// MARK:- 按钮点击事件
private extension PlayerView {
    @objc func _resumeOrPause() {
        _removeTimer()
        controlView.isShowResumeBtn = true
        
        guard let player = player else { return }
        
        controlView.resumeBtn.isSelected = !controlView.resumeBtn.isSelected
        if controlView.resumeBtn.isSelected {
            if _isPlayDone {
                _isPlayDone = false
                player.seek(to: .zero)
            }
            player.play()
            _addTimer()
        } else {
            player.pause()
        }
    }
    
    @objc func _togglePictureInPicture() {
        _addTimer()
        
        guard let pipCtr = pipCtr else { return }
        
        if pipCtr.isPictureInPictureActive {
            controlView.pipBtn?.isSelected = false
            pipCtr.stopPictureInPicture()
        } else {
            if let playerVC = playerVC_ {
                playerVC.stopPictureInPicture { [weak self] in
                    self?.controlView.pipBtn?.isSelected = true
                    self?.pipCtr?.startPictureInPicture()
                }
            } else {
                controlView.pipBtn?.isSelected = true
                pipCtr.startPictureInPicture()
            }
        }
    }
}

// MARK:- 事件监听
extension PlayerView {
    @objc fileprivate func _playDidEnd() {
        _isPlayDone = true
        controlView.resumeBtn.isSelected = false
        
        _removeTimer()
        controlView.isShowResumeBtn = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        if let player = player {
            let isSelected  = player.rate > 0
            if controlView.resumeBtn.isSelected != isSelected {
                _resumeOrPause()
            }
        }
        
        guard let pipCtr = pipCtr, let pipBtn = controlView.pipBtn else { return }
        pipBtn.isEnabled = pipCtr.isPictureInPicturePossible
        pipBtn.isSelected = pipCtr.isPictureInPictureActive
    }
    
    @objc fileprivate func _tap() {
        controlView.isShowResumeBtn = !controlView.isShowResumeBtn
        if controlView.isShowResumeBtn {
            _addTimer()
        }
    }
}

// MARK:- <UIGestureRecognizerDelegate>
extension PlayerView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if controlView.isShowResumeBtn {
            let location = gestureRecognizer.location(in: controlView)
            if controlView.blurView.frame.contains(location) {
                return false
            }
        }
        return true
    }
}

// MARK:- Timer
private extension PlayerView {
    func _addTimer() {
        _removeTimer()
        _timer = Timer.init(timeInterval: 5.0, repeats: false, block: { [weak self] (timer) in
            self?.controlView.isShowResumeBtn = false
        })
        guard let timer = _timer else {return}
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func _removeTimer() {
        guard let timer = _timer else { return }
        timer.invalidate()
        _timer = nil
    }
}
