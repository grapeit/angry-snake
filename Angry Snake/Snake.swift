//
//  Snake.swift
//  Angry Snake
//
//  Created by AV on 9/21/18.
//  Copyright © 2018 grapeit. All rights reserved.
//

import SpriteKit

class Snake {
  let size = CGFloat(10.0)
  let idleInteval = TimeInterval(0.5)
  let scene: SKScene
  var heads: [SKSpriteNode]
  var body = [SKNode]()
  var dead = false
  var direction = CGVector()
  var lastMove: TimeInterval

  var isDead: Bool {
    return dead || body.isEmpty
  }

  var headAt: CGPoint? {
    return body.first?.position
  }

  init(in scene: SKScene, at position: CGPoint, direction: CGVector, body: Int) {
    self.scene = scene
    self.heads = [
      SKSpriteNode.init(imageNamed: "north"),
      SKSpriteNode.init(imageNamed: "east"),
      SKSpriteNode.init(imageNamed: "south"),
      SKSpriteNode.init(imageNamed: "west")
    ]
    for n in self.heads {
      n.size = CGSize(width: size, height: size)
    }
    self.direction = direction
    self.lastMove = Date().timeIntervalSince1970
    let head = headNode()
    head.position = position
    self.body.append(head)
    self.scene.addChild(head)
    for i in 1...body {
      let nn = i == body ? tailNode() : bodyNode()
      nn.position = CGPoint(x: position.x - direction.dx * size * CGFloat(i), y: position.y - direction.dy * size * CGFloat(i))
      self.body.append(nn)
      self.scene.addChild(nn)
    }
  }

  func setDirection(_ direction: CGVector, snakes: [Snake]) {
    guard !isDead else {
      return
    }
    if self.direction != direction {
      if body.count > 1 && direction.isSameDirection(body[0].position.direction(to: body[1].position)) {
        return
      }
      self.direction = direction
      let h = headNode()
      h.position = headAt!
      body[0].removeFromParent()
      body[0] = h
      scene.addChild(h)
      if Date().timeIntervalSince1970 - lastMove < idleInteval {
        move(snakes: snakes)
      } else {
        lastMove = Date().timeIntervalSince1970
      }
    } else {
      move(snakes: snakes)
    }
  }

  func move(snakes: [Snake]) {
    guard !isDead, let hp = headAt, (direction.dx != 0.0 || direction.dy != 0.0) else {
      return
    }
    let np = CGPoint(x: hp.x + direction.dx * size, y: hp.y + direction.dy * size)
    var collision: Collision = .none
    var eatee: Snake?
    for s in snakes {
      collision = s.checkCollision(np)
      if collision != .none {
        if collision == .body && s === self && body.count > 2 && body[body.count - 2].position.distance(to: np) < size / 2 {
          collision = .tail
        }
        if collision == .tail {
          eatee = s
        }
        break
      }
    }
    switch collision {
    case .body:
      die()
    case .none:
      body[0].position = np
      var p = hp
      for n in body[1...] {
        let op = n.position
        n.position = p
        p = op
      }
    case .tail:
      body[0].position = np
      let nn = body.count > 1 ? bodyNode() : tailNode()
      nn.position = hp
      nn.strokeColor = .orange
      body.insert(nn, at: 1)
      scene.addChild(nn)
      eatee?.seize()
    }
    lastMove = Date().timeIntervalSince1970
  }

  func seize() {
    if body.count > 2 {
      body.last!.position = body[body.count - 2].position
      body[body.count - 2].removeFromParent()
      body.remove(at: body.count - 2)
    } else if body.count > 0 {
      body.last!.removeFromParent()
      body.removeLast()
    }
    if body.isEmpty {
      die()
    }
  }

  func die() {
    dead = true
    repaint(.blue)
  }

  enum Collision {
    case none, body, tail
  }

  func checkCollision(_ at: CGPoint) -> Collision {
    if body.isEmpty {
      return Collision.none
    }
    if body.count == 1 {
      return body[0].position.distance(to: at) < size / 2 ? Collision.tail : Collision.none
    }
    if body.last!.position.distance(to: at) < size / 2 {
      return Collision.tail
    }
    for i in body {
      if i.position.distance(to: at) < size / 2 {
        return Collision.body
      }
    }
    return Collision.none
  }

  func activate() {
    repaint(isDead ? .blue : .orange)
  }

  func deactivate() {
    repaint(isDead ? .blue : .white)
  }

  func repaint(_ color: UIColor) {
    for n in heads {
      n.run(SKAction.colorize(with: color, colorBlendFactor: 0.7, duration: 0.0))
    }
    for n in body {
      if let n = n as? SKShapeNode {
        n.strokeColor = color
      }
    }
  }

  private func headNode() -> SKNode {
    if (direction.dy > 0) {
      return heads[0]
    } else if (direction.dx > 0) {
      return heads[1]
    } else if (direction.dy < 0) {
      return heads[2]
    } else if (direction.dx < 0) {
      return heads[3]
    }
    return SKShapeNode.init(ellipseOf: CGSize(width: size, height: size))
  }

  private func bodyNode() -> SKShapeNode {
    return SKShapeNode.init(ellipseOf: CGSize(width: size * 0.8, height: size * 0.8))
  }

  private func tailNode() -> SKShapeNode {
    return SKShapeNode.init(ellipseOf: CGSize(width: size * 0.6, height: size * 0.6))
  }
}
