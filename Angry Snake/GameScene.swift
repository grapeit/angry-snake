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
  var touches = [Touch]()
  var prairie: Prairie!

  override func didMove(to view: SKView) {

  }

  override func update(_ currentTime: TimeInterval) {
    
  }

  func onTouch(from: CGPoint, to: CGPoint) {
    prairie.onTouch(from: from, to: to)
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
