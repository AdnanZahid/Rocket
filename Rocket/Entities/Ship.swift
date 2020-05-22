//
//  Ship.swift
//  Rocket
//
//  Created by Adnan Zahid on 22/05/2020.
//  Copyright © 2020 Rocket. All rights reserved.
//

import Foundation
import SpriteKit

class Ship {

  private enum Constants {
    static let size: CGFloat = 20
    static let cornerRadius: CGFloat = 5
    static let linearDamping: CGFloat = 10
    static let jumpSpeed: CGFloat = 1
  }

  var node = SKShapeNode(rectOf: CGSize(width: Constants.size, height: Constants.size), cornerRadius: Constants.cornerRadius)

  init() {
    node.fillColor = .white
    node.physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
    node.physicsBody?.linearDamping = Constants.linearDamping
  }

  func getNode() -> SKShapeNode {
    return node
  }

  func getPhysicsBody() -> SKPhysicsBody? {
    return node.physicsBody
  }

  func setPosition(_ point: CGPoint) {
    node.position = point
  }

  func jump() {
    node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: Constants.jumpSpeed))
  }
}
