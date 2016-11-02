//
//  Coin.swift
//  _zero
//
//  Created by Jake Johnson on 4/19/16.
//  Copyright © 2016 Jake Johnson. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode {
    var _scene: GameScene
    
    init(color: UIColor, size: CGSize, scene: GameScene) {
        _scene = scene
        
        super.init(texture: nil, color: color, size: size)
        
        position = CGPoint(x:_scene.frame.midX + frame.size.width + 8*8, y:_scene.frame.midY + frame.size.height*3 + 8*3 + 8*8)
        zPosition = -700
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = CategoryBitMasks.Coin
        physicsBody!.contactTestBitMask = CategoryBitMasks.Hero
        physicsBody!.collisionBitMask = CategoryBitMasks.None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func randomPosition() -> CGPoint {
        let positions = [
            CGPoint(x:_scene.frame.midX - frame.size.width - 8*8, y:_scene.frame.midY),
            CGPoint(x:_scene.frame.midX - frame.size.width - 8*8, y:_scene.frame.midY + frame.size.height + 8*8),
            CGPoint(x:_scene.frame.midX - frame.size.width - 8*8, y:_scene.frame.midY + frame.size.height*3 + 8*3 + 8*8),
            CGPoint(x:_scene.frame.midX + frame.size.width + 8*8, y:_scene.frame.midY),
            CGPoint(x:_scene.frame.midX + frame.size.width + 8*8, y:_scene.frame.midY + frame.size.height + 8*8),
            CGPoint(x:_scene.frame.midX + frame.size.width + 8*8, y:_scene.frame.midY + frame.size.height*3 + 8*3 + 8*8),
            CGPoint(x:_scene.frame.midX, y:_scene.frame.midY),
            CGPoint(x:_scene.frame.midX, y:_scene.frame.midY + frame.size.height + 8*8),
            CGPoint(x:_scene.frame.midX, y:_scene.frame.midY + frame.size.height*3 + 8*3 + 8*8)
        ]
        
        return positions[Int(arc4random_uniform(UInt32(positions.count)))]
    }
    
    func explode() {
        run(SKAction.fadeOut(withDuration: 0.1))
//        if let explosion = SKEmitterNode(fileNamed: "DestroyCoin") {
//            explosion.position = position
//            explosion.zPosition = -700
//            _scene.addChild(explosion)
//        }
    }
    
    func respawn() {
        let newPosition = randomPosition()
        
        if position.ceil().equalTo(newPosition.ceil()) {
            respawn()
        } else {
            let sequence = SKAction.sequence([SKAction.move(to: newPosition, duration: 0.1), SKAction.fadeIn(withDuration: 0.2)])
            
            run(sequence)
        }
    }
}
