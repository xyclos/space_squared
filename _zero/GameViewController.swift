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
            
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            adBannerView = GADBannerView(adSize: GADAdSizeFullWidthPortraitWithHeight(100), origin: CGPointMake(0, CGRectGetMaxY(self.view.frame) - 100))
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            adBannerView = GADBannerView(adSize: GADAdSizeFullWidthPortraitWithHeight(50), origin: CGPointMake(0, CGRectGetMaxY(self.view.frame) - 50))
        }
        
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        adBannerView.adUnitID = "ca-app-pub-1809375000042830/1995670701"
        
        let reqAd = GADRequest()
        reqAd.testDevices = [kGADSimulatorID]
        adBannerView.loadRequest(reqAd)
        self.view.addSubview(adBannerView)
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
