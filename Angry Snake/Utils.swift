//
//  Utils.swift
//  Angry Snake
//
//  Created by AV on 9/21/18.
//  Copyright © 2018 grapeit. All rights reserved.
//

import CoreGraphics

extension CGFloat {
  func sign() -> CGFloat {
    if self < 0 {
      return -1
    } else if self > 0 {
      return 1
    }
    return 0
  }
}

extension CGPoint {
  func distance(to point: CGPoint) -> CGFloat {
    return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
  }
  func direction(to point: CGPoint) -> CGVector {
    return CGVector(dx: point.x - x, dy: point.y - y)
  }
}

extension CGVector {
  func isSameDirection(_ to: CGVector) -> Bool {
    return dx.sign() == to.dx.sign() && dy.sign() == to.dy.sign()
  }
}
