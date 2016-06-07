//
//  SKNode.swift
//  _zero
//
//  Created by Jake Johnson on 6/7/16.
//  Copyright © 2016 Jake Johnson. All rights reserved.
//

import SpriteKit

extension SKNode {
    func shake(times: Int) {
        let initialPoint: CGPoint = self.position
        let amplitudeX = 32
        let amplitudeY = 2
        var randomActions = [SKAction]()
        var randX: CGFloat
        var randY: CGFloat
        var action: SKAction
        for _ in 0...times {
            randX = initialPoint.x + CGFloat(arc4random()) % CGFloat(amplitudeX - amplitudeX/2)
            randY = CGFloat(initialPoint.y) + CGFloat(arc4random()) % CGFloat(amplitudeY - amplitudeY/2)
            action = SKAction.moveTo(CGPointMake(randX, randY), duration: 0.01)
            randomActions.append(action)
        }
        let rep = SKAction.sequence(randomActions)
        self.runAction(rep, completion: { self.position = initialPoint })
    }
}