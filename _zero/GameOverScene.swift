//
//  GameOverScene.swift
//  _zero
//
//  Created by Jake Johnson on 6/11/16.
//  Copyright © 2016 Jake Johnson. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let fontName = "Fipps-Regular"
    
    var retryLabel: SKLabelNode {
        return SKLabelNode(fontNamed: self.fontName)
    }
    
    var mainMenuLabel: SKLabelNode {
        return SKLabelNode(fontNamed: self.fontName)
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        self.alpha = 0.75
        
        buildMenu()
    }
    
    func buildMenu() {
        retryLabel.text = "Retry"
        retryLabel.fontSize = 40
        retryLabel.position = CGPoint(x: self.frame.midX, y: 25.0)
        
        addChild(retryLabel)
    }
}
