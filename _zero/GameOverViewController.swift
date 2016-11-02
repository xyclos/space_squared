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
            
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
