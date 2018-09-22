//
//  Snake.swift
//  Angry Snake
//
//  Created by AV on 9/21/18.
//  Copyright © 2018 grapeit. All rights reserved.
//

import SpriteKit

class Snake {
  let size = CGFloat(20.0)
  let tapInteval = TimeInterval(0.5)
  let scene: SKScene
  var body = [SKNode]()
  var direction = CGVector()
  var lastMove: TimeInterval

  var isDead: Bool {
    return body.isEmpty
  }

  init(in scene: SKScene, at position: CGPoint) {
    self.scene = scene
    self.lastMove = Date().timeIntervalSince1970
    let head = headNode()
    head.position = position
    body.append(head)
    scene.addChild(head)
  }

  func setDirection(_ direction: CGVector) {
    if self.direction != direction {
      if body.count > 1 && direction.isSameDirection(body[body.count - 1].position.direction(to: body[body.count - 2].position)) {
        return
      }
      self.direction = direction
      let nn = headNode()
      nn.position = body.last!.position
      body[body.count - 1].removeFromParent()
      body[body.count - 1] = nn
      scene.addChild(nn)
      if Date().timeIntervalSince1970 - lastMove < tapInteval {
        advance()
      } else {
        lastMove = Date().timeIntervalSince1970
      }
    } else {
      advance()
    }
  }

  func advance() {
    guard !body.isEmpty && (direction.dx != 0.0 || direction.dy != 0.0) else {
      return
    }
    var p: CGPoint?
    for n in body.reversed() {
      if let x = p {
        p = n.position
        n.position = x
      } else {
        p = n.position
        n.position = CGPoint(x: p!.x + direction.dx * size, y: p!.y + direction.dy * size)
      }
    }
    lastMove = Date().timeIntervalSince1970
  }

  func feed() {
    guard let head = body.last, (direction.dx != 0.0 || direction.dy != 0.0) else {
      return
    }
    let nn = body.count > 1 ? bodyNode() : tailNode()
    nn.position = head.position
    body.insert(nn, at: body.count - 1)
    head.position = CGPoint(x: head.position.x + direction.dx * size, y: head.position.y + direction.dy * size)
    scene.addChild(nn)
    lastMove = Date().timeIntervalSince1970
  }

  func seize() {

  }

  private func headNode() -> SKNode {
    var image: String?
    if (direction.dx < 0) {
      image = "west"
    } else if (direction.dx > 0) {
      image = "east"
    } else if (direction.dy < 0) {
      image = "south"
    } else if (direction.dy > 0) {
      image = "north"
    }
    guard let i = image else {
      return SKShapeNode.init(ellipseOf: CGSize(width: size, height: size))
    }
    let n = SKSpriteNode.init(imageNamed: i)
    n.size = CGSize(width: size, height: size)
    return n
  }

  private func bodyNode() -> SKNode {
    return SKShapeNode.init(ellipseOf: CGSize(width: size * 0.8, height: size * 0.8))
  }

  private func tailNode() -> SKNode {
    return SKShapeNode.init(ellipseOf: CGSize(width: size * 0.6, height: size * 0.6))
  }
}
