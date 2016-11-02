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
        
        name = "hero"
        position = CGPoint(x:_scene.frame.midX - frame.size.width - 8*3, y:_scene.frame.midY)
        zPosition = -800
        name = "hero"
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = CategoryBitMasks.Hero
        physicsBody!.contactTestBitMask = CategoryBitMasks.Coin | CategoryBitMasks.Projectile
        physicsBody!.collisionBitMask = CategoryBitMasks.None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(_ direction: Direction) {
        var newPosition = position
        if direction == .right {
            newPosition = CGPoint(x: position.x + frame.size.width + 8*3, y: position.y)
        } else if direction == .left {
            newPosition = CGPoint(x: position.x - frame.size.width - 8*3, y: position.y)
        } else if direction == .up {
            newPosition = CGPoint(x: position.x, y: position.y + frame.size.height + 8*3)
        } else if direction == .down {
            newPosition = CGPoint(x: position.x, y: position.y - frame.size.height - 8*3)
        }
        
        if _scene.playField.frame.contains(newPosition) {
            run(SKAction.move(to: newPosition, duration: 0.17))
        }
    }
}
