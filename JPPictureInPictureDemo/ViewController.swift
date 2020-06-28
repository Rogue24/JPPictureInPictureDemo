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
        
        let btn = JPBounceButton.bounceButton()
        btn.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        view.addSubview(btn)
        
        btn.touchUpInside = { [weak self] in
            guard let navCtr = self?.navigationController else {return}
            
            if let playerVC = playerVC_ {
                navCtr.pushViewController(playerVC, animated: true)
                return
            }
            
            let videoPath = Bundle.main.path(forResource: "iphone-11-pro", ofType: "mp4")
            let imagePath = Bundle.main.path(forResource: "iphone-11-pro_0", ofType: "jpg")
            
            let vc = iPhone11ProViewController()
            vc.videoPath = videoPath ?? ""
            vc.imagePath = imagePath ?? ""
            
            navCtr.pushViewController(vc, animated: true)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

