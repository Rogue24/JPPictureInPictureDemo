//
//  ViewController.swift
//  JPPictureInPictureDemo
//
//  Created by 周健平 on 2020/6/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Hi"
        
        let btn0 = JPBounceButton.bounceButton()
        btn0.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.3)
        view.addSubview(btn0)
        
        let btn1 = JPBounceButton.bounceButton()
        btn1.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.7)
        view.addSubview(btn1)
        
        btn0.touchUpInside = { [weak self] in
            self?.__pushPlayerVC(false)
        }
        
        btn1.touchUpInside = { [weak self] in
            self?.__pushPlayerVC(true)
        }
    }
    
    func __pushPlayerVC(_ isPro: Bool) {
        guard let navCtr = self.navigationController else {return}
        if let playerVC = playerVC_ {
            let videoPath = isPro ? iPhone11ProViewController.videoPath() : iPhone11ViewController.videoPath()
            if playerVC.videoPath == videoPath {
                navCtr.pushViewController(playerVC, animated: true)
                return
            }
        }
        let playerVC = isPro ? iPhone11ProViewController() : iPhone11ViewController()
        navCtr.pushViewController(playerVC, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

