//
//  GameOverViewController.swift
//  _zero
//
//  Created by Jake Johnson on 6/11/16.
//  Copyright © 2016 Jake Johnson. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameOverScene(fileNamed:"GameOverScene") {
            let skView = self.view as! SKView
            skView.ignoresSiblingOrder = false
            
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
