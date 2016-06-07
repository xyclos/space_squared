//
//  GameScene.swift
//  _zero
//
//  Created by Jake Johnson on 4/18/16.
//  Copyright (c) 2016 Jake Johnson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum Mode {
        case Menu, Play, Action, Default
    }
    
    var currentMode = Mode.Default
    
    var score: Int = 0 {
        didSet {
            updateScore(score)
        }
    }
    
    var _hero = SKSpriteNode() as? Hero
    var _coin = SKSpriteNode() as? Coin
    let playField = SKShapeNode(rectOfSize: CGSize(width: 320, height: 320))
    
    let titleLabel = SKLabelNode(fontNamed:"Fipps-Regular")
    let playLabel = SKLabelNode(fontNamed: "Fipps-Regular")
    var scoreLabel = SKLabelNode(fontNamed: "Fipps-Regular")
    
    var menuGroup = SKNode()
    
    //mark: actions
    let fadeInAction = SKAction.fadeAlphaTo(0.7, duration: 1)
    let fadeInAction2 = SKAction.fadeAlphaTo(1, duration: 1)
    let moveUpAction = SKAction.moveByX(0, y: 200, duration: 1)
    let fadeOutAction = SKAction.fadeOutWithDuration(0.5)
    let moveDownAction = SKAction.moveByX(0, y: -150, duration: 1)
    let killAction = SKAction.removeFromParent()
    
    var lastUpdateTimeInterval: CFTimeInterval? = 0
    
    override func didMoveToView(view: SKView) {
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(_:)))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp(_:)))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown(_:)))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
        self.physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor.blackColor()
        
        if let starField = SKEmitterNode(fileNamed: "StarField") {
            starField.position = CGPointMake(size.width/2, size.height)
            starField.zPosition = -1000
            addChild(starField)
        }
        
        buildMenu()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = nodeAtPoint(location)
            
            if let name = node.name {
                switch name {
                case "play":
                    currentMode = Mode.Menu
                default:
                    currentMode = Mode.Default
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if currentMode == Mode.Menu {
            hideMenu()
        } else if currentMode == Mode.Play {
            showPlayField()
        } else if currentMode == Mode.Action {
            spawnEnemies()
        }
    }
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask != contact.bodyB.categoryBitMask {
            let contactMask = contact.bodyA.categoryBitMask & contact.bodyB.categoryBitMask
            switch contactMask {
            case CategoryBitMasks.Projectile:
                _hero!.shake(3)
                playField.shake(3)
                score = 0
                break
            case CategoryBitMasks.Coin:
                _coin!.explode()
                _coin!.respawn()
                score += 1
                break
            default: break
            }
        }
    }
    
    func buildMenu() {
        titleLabel.text = "_zero"
        titleLabel.fontSize = 25
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        addChild(titleLabel)
        
        playLabel.text = "play"
        playLabel.fontSize = 10
        playLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 100)
        playLabel.name = "play"
        
        menuGroup.addChild(playLabel)
        
        addChild(menuGroup)
    }
    
    func hideMenu() {
        let titleSequence = SKAction.sequence([moveDownAction])
        
        titleLabel.runAction(titleSequence)
        
        let menuSequence = SKAction.group([fadeOutAction, moveDownAction])
        
        menuGroup.runAction(menuSequence)
        
        currentMode = Mode.Play
    }
    
    func showPlayField() {
        
        playField.fillColor = SKColor.blackColor()
        playField.alpha = 0
        playField.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 100)
        playField.zPosition = -900
        
        addChild(playField)
        
        let playFieldSequence = SKAction.group([moveUpAction, fadeInAction])
        
        playField.runAction(playFieldSequence)
        
        currentMode = Mode.Default
        
        scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height*0.90)
        scoreLabel.fontSize = 20
        scoreLabel.color = SKColor.whiteColor()
        scoreLabel.alpha = 0
        scoreLabel.text = "\(score)"
        
        addChild(scoreLabel)
        
        scoreLabel.runAction(fadeInAction2)
        
        _hero = Hero(color: SKColor.whiteColor(), size: CGSize(width: 80, height: 80), scene: self)
        _hero!.alpha = 0
        addChild(_hero!)
        _hero!.runAction(fadeInAction2)
    
        
        _coin = Coin(color: SKColor.yellowColor(), size: CGSize(width: 40, height: 40), scene: self)
        _coin!.alpha = 0
        addChild(_coin!)
        _coin!.runAction(fadeInAction2)
        
//        let testEnemy = Projectile(color: SKColor.redColor(), size: CGSize(width: 20, height: 20), scene: self)
//        testEnemy.position = CGPoint(x: self.frame.width + 8*3, y: CGRectGetMidY(self.frame))
//        addChild(testEnemy)
    }
    
    func updateScore(score: Int) {
        scoreLabel.text = "\(score)"
        
        if score == 1 {
            currentMode = Mode.Action
        }
    }
    
    func spawnEnemies() {
        let baseDelay = 5
        let delay = Double(max(baseDelay*self.score/score, baseDelay))
//        let delay = 1.0
        let wait = SKAction.waitForDuration(delay)
        let run = SKAction.runBlock({
            let enemy = Projectile(color: SKColor.redColor(), size: CGSize(width: 20, height: 20), scene: self)
            let opposingPositions = enemy.randomOpposingPositions()
            let randomTupleIndex = self.randomIndexFromTuple(opposingPositions)
            let firstPosition = randomTupleIndex == 0 ? opposingPositions.0 : opposingPositions.1
            let secondPosition = firstPosition == opposingPositions.0 ? opposingPositions.1 : opposingPositions.0
            enemy.position = firstPosition
            enemy.runAction(SKAction.sequence([SKAction.moveTo(secondPosition, duration: 5), self.killAction]))
            self.addChild(enemy)
        })
        runAction(SKAction.repeatActionForever(SKAction.sequence([run, wait])))
        currentMode = Mode.Default
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        _hero!.move(.Right)
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        _hero!.move(.Left)
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        _hero!.move(.Up)
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        _hero!.move(.Down)
    }
    
    func randomIndexFromTuple<C>(tuple:C) -> Int {
        let mirror = Mirror(reflecting: tuple)
        let count = mirror.children.count
        return Int(arc4random_uniform(UInt32(count)))
    }

}
