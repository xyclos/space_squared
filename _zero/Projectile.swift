//
//  Projectile.swift
//  _zero
//
//  Created by Jake Johnson on 4/19/16.
//  Copyright © 2016 Jake Johnson. All rights reserved.
//

import SpriteKit

class Projectile: SKSpriteNode {
    var _scene: GameScene
    
    init(color: UIColor, size: CGSize, scene: GameScene) {
        _scene = scene
        
        super.init(texture: nil, color: color, size: size)
        
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = CategoryBitMasks.Projectile
        physicsBody!.contactTestBitMask = CategoryBitMasks.Hero
        physicsBody!.collisionBitMask = CategoryBitMasks.None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func randomOpposingPositions() -> (CGPoint, CGPoint) {
        let midX = CGRectGetMidX(_scene.frame)
        let midY = CGRectGetMidY(_scene.frame)
        let height = frame.size.height
        let width = frame.size.width
        var positions = [(CGPoint,CGPoint)]()

        // vertical center
        positions.append((CGPoint(x: midX, y: _scene.frame.height), CGPoint(x: midX, y: _scene.frame.height * -1)))
        // vertical left
        positions.append((CGPoint(x: midX - width - 8*11, y: _scene.frame.height), CGPoint(x: midX - width - 8*11, y: _scene.frame.height * -1)))
        // vertical right
        positions.append((CGPoint(x: midX + width + 8*11, y: _scene.frame.height), CGPoint(x: midX + width + 8*11, y: _scene.frame.height * -1)))
        
        // horizontal bottom
        positions.append((CGPoint(x: _scene.frame.width, y: midY), CGPoint(x: _scene.frame.width * -1, y: midY)))
        // horizontal center
        positions.append((CGPoint(x: _scene.frame.width, y: midY + height + 8*11), CGPoint(x: _scene.frame.width * -1, y: midY + height + 8*11)))
        // horizontal top
        positions.append((CGPoint(x: _scene.frame.width, y: midY + height*6 + 8*11), CGPoint(x: _scene.frame.width * -1, y: midY + height*6 + 8*11)))
        
        return positions[Int(arc4random_uniform(UInt32(positions.count)))]
    }
    
    func explode() {
        runAction(SKAction.fadeOutWithDuration(0.1))
    }
}
