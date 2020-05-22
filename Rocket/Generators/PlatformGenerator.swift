//
//  PlatformGenerator.swift
//  Rocket
//
//  Created by Adnan Zahid on 22/05/2020.
//  Copyright © 2020 Rocket. All rights reserved.
//

import Foundation
import SpriteKit

class PlatformGenerator {

  private enum Constants {
    static let width: CGFloat = 100
    static let height: CGFloat = 200
    static let cornerRadius: CGFloat = 0
    static let generationInterval = 500
  }

  private var currentFrames = 499

  var shouldGenerate: Bool {
    if currentFrames == Constants.generationInterval { currentFrames = 0; return true; }
    return false
  }

  func generate(at point: CGPoint, screenSize: CGSize) -> SKNode {
    let size = CGSize(width: Constants.width, height: screenSize.height)
    let node = SKShapeNode(rectOf: CGSize(width: Constants.width, height: screenSize.height))
    node.position = point
    node.strokeColor = .clear
    node.addChild(generateTopPlatform(parentSize: size))
    node.addChild(generateBottomPlatform(parentSize: size))
    node.physicsBody = SKPhysicsBody(rectangleOf: size)
    node.physicsBody?.affectedByGravity = false
    node.physicsBody?.isDynamic = false
    return node
  }

  func incrementFrame() {
    currentFrames += 1
  }

  private func generateTopPlatform(parentSize: CGSize) -> SKNode {
    let x: CGFloat = 0
    let y: CGFloat = parentSize.height/2 - Constants.height/2
    return generatePlatform(at: CGPoint(x: x, y: y))
  }

  private func generateBottomPlatform(parentSize: CGSize) -> SKNode {
    let x: CGFloat = 0
    let y: CGFloat = -(parentSize.height/2 - Constants.height/2)
    return generatePlatform(at: CGPoint(x: x, y: y))
  }

  private func generatePlatform(at point: CGPoint) -> SKNode {
    let size = CGSize(width: Constants.width, height: Constants.height)
    let node = SKShapeNode(rectOf: size, cornerRadius: Constants.cornerRadius)
    node.fillColor = .white
    node.position = point
    node.physicsBody = SKPhysicsBody(rectangleOf: size)
    node.physicsBody?.affectedByGravity = false
    node.physicsBody?.isDynamic = false
    return node
  }
}
