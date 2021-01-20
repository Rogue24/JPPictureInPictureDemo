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
        
        let btn0 = FunButton.build { [weak self] in self?.pushPlayerVC(false) }
        btn0.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.3)
        view.addSubview(btn0)
        
        let btn1 = FunButton.build { [weak self] in self?.pushPlayerVC(true) }
        btn1.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.7)
        view.addSubview(btn1)
    }
    
    func pushPlayerVC(_ isPro: Bool) {
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

