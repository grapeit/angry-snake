//
//  GameScene.swift
//  Angry Snake
//
//  Created by AV on 9/21/18.
//  Copyright © 2018 grapeit. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  let swipeDistance = CGFloat(20.0)
  var touches = [Touch]()
  var snakes: [Snake]!

  var activeSnake = 0 {
    willSet {
      snakes[activeSnake].deactivate()
      snakes[newValue].activate()
    }
  }

  override func didMove(to view: SKView) {
    snakes = [
      Snake(in: self, at: CGPoint(x: -100.0, y: 100.0), direction: CGVector(dx: 0.0, dy: -1.0), body: 10),
      Snake(in: self, at: CGPoint(x: 0.0, y: 0.0), direction: CGVector(dx: 0.0, dy: 1.0), body: 10),
      Snake(in: self, at: CGPoint(x: 100.0, y: 100.0), direction: CGVector(dx: 0.0, dy: -1.0), body: 10)
    ]
    snakes[activeSnake].activate()
  }

  override func update(_ currentTime: TimeInterval) {
    
  }

  func onTouch(from: CGPoint, to: CGPoint) {
    let snake = snakes[activeSnake]
    if (from.distance(to: to) < swipeDistance) {
      snake.move(snakes: snakes)
    } else {
      if abs(from.x - to.x) > abs(from.y - to.y) {
        snake.setDirection(CGVector(dx: to.x > from.x ? 1 : -1, dy : 0), snakes: snakes)
      } else {
        snake.setDirection(CGVector(dx: 0, dy: to.y > from.y ? 1 : -1), snakes: snakes)
      }
    }
  }

  func touchDown(_ touch: UITouch) {
    for t in touches {
      if t.touch === touch {
        return
      }
    }
    touches.append(Touch(touch: touch, initPos: touch.location(in: self)))
  }

  func touchMoved(_ touch: UITouch) {

  }

  func touchUp(_ touch: UITouch) {
    var idx = 0
    for t in touches {
      if t.touch === touch {
        onTouch(from: t.initPos, to: touch.location(in: self))
        touches.remove(at: idx)
        return
      }
      idx += 1
    }
  }

  func touchCanceled(_ touch: UITouch) {

  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {
      self.touchDown(t)
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {
      self.touchMoved(t)
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {
      self.touchUp(t)
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {
      self.touchCanceled(t)
    }
  }
}

struct Touch {
  let touch: UITouch
  let initPos: CGPoint
}
