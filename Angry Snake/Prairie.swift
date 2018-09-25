//
//  Prairie.swift
//  Angry Snake
//
//  Created by AV on 9/24/18.
//  Copyright © 2018 grapeit. All rights reserved.
//

import Foundation
import SpriteKit

class Prairie {
  let swipeDistance = CGFloat(20.0)
  var snakes: [Snake]

  init(in scene: SKScene, snakes: Int) {
    self.snakes = [Snake]()
    let dist = CGFloat(80.0)
    var x = 0.0 - dist * CGFloat(snakes - 1) / 2.0
    var y = CGFloat(100.0)
    for _ in 0..<snakes {
      self.snakes.append(Snake(in: scene, at: CGPoint(x: x, y: y), direction: CGVector(dx: 0.0, dy: y.sign()), body: 10))
      x += dist
      y *= -1.0
    }
  }

  var activeSnake = 0 {
    willSet {
      snakes[activeSnake].deactivate()
      snakes[newValue].activate()
    }
  }

  func onTouch(from: CGPoint, to: CGPoint) {
    let snake = snakes[activeSnake]
    if from.distance(to: to) < swipeDistance {
      snake.move(snakes: snakes)
    } else {
      if abs(from.x - to.x) > abs(from.y - to.y) {
        snake.setDirection(CGVector(dx: to.x > from.x ? 1 : -1, dy : 0), snakes: snakes)
      } else {
        snake.setDirection(CGVector(dx: 0, dy: to.y > from.y ? 1 : -1), snakes: snakes)
      }
    }
  }

}
