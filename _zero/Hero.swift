//
//  Hero.swift
//  _zero
//
//  Created by Jake Johnson on 4/19/16.
//  Copyright © 2016 Jake Johnson. All rights reserved.
//

import SpriteKit

class Hero: SKSpriteNode {
    var _scene: GameScene
    
    init(color: UIColor, size: CGSize, scene: GameScene) {
        _scene = scene
        
        super.init(texture: nil, color: color, size: size)
        
        position = CGPoint(x:CGRectGetMidX(_scene.frame) - frame.size.width - 8*3, y:CGRectGetMidY(_scene.frame))
        zPosition = -800
        name = "hero"
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = CategoryBitMasks.Hero
        physicsBody!.contactTestBitMask = CategoryBitMasks.Coin | CategoryBitMasks.Projectile
        physicsBody!.collisionBitMask = CategoryBitMasks.None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(direction: Direction) {
        var newPosition = position
        if direction == .Right {
            newPosition = CGPointMake(position.x + frame.size.width + 8*3, position.y)
        } else if direction == .Left {
            newPosition = CGPointMake(position.x - frame.size.width - 8*3, position.y)
        } else if direction == .Up {
            newPosition = CGPointMake(position.x, position.y + frame.size.height + 8*3)
        } else if direction == .Down {
            newPosition = CGPointMake(position.x, position.y - frame.size.height - 8*3)
        }
        
        if CGRectContainsPoint(_scene.playField.frame, newPosition) {
            runAction(SKAction.moveTo(newPosition, duration: 0.17))
        }
    }
}
