//
//  GameViewController.swift
//  _zero
//
//  Created by Jake Johnson on 4/18/16.
//  Copyright (c) 2016 Jake Johnson. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate {
    
    var adBannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = false
            
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            adBannerView = GADBannerView(adSize: GADAdSizeFullWidthPortraitWithHeight(100), origin: CGPoint(x: 0, y: self.view.frame.maxY - 100))
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            adBannerView = GADBannerView(adSize: GADAdSizeFullWidthPortraitWithHeight(50), origin: CGPoint(x: 0, y: self.view.frame.maxY - 50))
        }
        
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        adBannerView.adUnitID = "ca-app-pub-1809375000042830/1995670701"
        
        let reqAd = GADRequest()
        reqAd.testDevices = [kGADSimulatorID]
        adBannerView.load(reqAd)
        self.view.addSubview(adBannerView)
    }

    override var shouldAutorotate : Bool {
        return false
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
