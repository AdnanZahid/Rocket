//
//  GameScene.swift
//  Rocket
//
//  Created by Adnan Zahid on 22/05/2020.
//  Copyright © 2020 Rocket. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

  private typealias CategoryMasks = Constants.CategoryMasks
  private enum Constants {
    static let scoreXOffset: CGFloat = 100
    static let scoreYOffset: CGFloat = 50
    static let heroXPosition: CGFloat = 100
    static let worldSpeed: CGFloat = 1
    enum CategoryMasks: UInt32 {
      case hero = 0b01
      case obstacle = 0b10
      case nonObstacle = 0b11
      case collision = 0
    }
  }

  var score = 0
  let scoreLabel = SKLabelNode()
  var screenSize: CGSize!
  let world = SKNode()
  let hero = Ship()
  let platformGenerator = PlatformGenerator()
  var platforms: [SKNode] = []

  override func sceneDidLoad() {
    super.sceneDidLoad()
    setupGame()
  }

  override func keyDown(with event: NSEvent) {
    makeHeroJump()
  }

  override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)
    moveWorldLeft()
    generatePlatformIfNeeded()
  }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    let bodyA = contact.bodyA
    let bodyB = contact.bodyB
    let isObstacleContact = bodyA.categoryBitMask == CategoryMasks.obstacle.rawValue ||
      bodyB.categoryBitMask == CategoryMasks.obstacle.rawValue
    let isNonobstacleContact = bodyA.categoryBitMask == CategoryMasks.nonObstacle.rawValue ||
      bodyB.categoryBitMask == CategoryMasks.nonObstacle.rawValue
    if isObstacleContact {
      gameOver()
    } else if isNonobstacleContact {
      hurdlePassed()
    }
  }
}

// MARK: - Private functions
extension GameScene {
  private func setupGame() {
    setupWorld()
    setupScore()
    setupHero()
    setupContactSystem()
  }

  private func restartGame() {
    removeAllNodes()
    setupGame()
  }

  private func gameOver() {
    score = 0
    restartGame()
  }

  private func hurdlePassed() {
    incrementScore()
  }

  private func removeAllNodes() {
    children.forEach { $0.removeAllChildren() }
    removeAllChildren()
  }

  private func makeHeroJump() {
    hero.jump()
  }

  private func moveWorldLeft() {
    world.position.x -= Constants.worldSpeed
  }

  private func setupScore() {
    scoreLabel.text = "Score: \(score)"
    scoreLabel.position = CGPoint(x: screenSize.width - Constants.scoreXOffset,
                                  y: screenSize.height - Constants.scoreYOffset)
    addChild(scoreLabel)
  }

  private func incrementScore() {
    score += 1
    scoreLabel.text = "Score: \(score)"
  }

  private func setupWorld() {
    screenSize = CGSize(width: frame.width, height: frame.height)
    addChild(world)
  }

  private func setupHero() {
    hero.setPosition(CGPoint(x: Constants.heroXPosition, y: frame.midY))
    hero.getPhysicsBody()?.categoryBitMask = CategoryMasks.hero.rawValue
    hero.getPhysicsBody()?.contactTestBitMask = CategoryMasks.obstacle.rawValue | CategoryMasks.nonObstacle.rawValue
    hero.getPhysicsBody()?.collisionBitMask = CategoryMasks.collision.rawValue
    addChild(hero.getNode())
  }

  private func setupContactSystem() {
    physicsWorld.contactDelegate = self
  }

  private func generatePlatformIfNeeded() {
    platformGenerator.incrementFrame()
    if platformGenerator.shouldGenerate {
      let platform = platformGenerator.generate(at: CGPoint(x: screenSize.width - world.position.x, y: frame.midY),
                                                screenSize: screenSize)
      platforms.append(platform)
      platform.physicsBody?.categoryBitMask = CategoryMasks.nonObstacle.rawValue
      platform.physicsBody?.contactTestBitMask = CategoryMasks.hero.rawValue
      platform.physicsBody?.collisionBitMask = CategoryMasks.collision.rawValue
      platform.children.forEach {
        $0.physicsBody?.categoryBitMask = CategoryMasks.obstacle.rawValue
        $0.physicsBody?.contactTestBitMask = CategoryMasks.hero.rawValue
        $0.physicsBody?.collisionBitMask = CategoryMasks.collision.rawValue
      }
      world.addChild(platform)
    }
  }
}
