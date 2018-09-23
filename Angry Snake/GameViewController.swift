//
//  GameViewController.swift
//  Angry Snake
//
//  Created by AV on 9/21/18.
//  Copyright © 2018 grapeit. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

  @IBOutlet weak var snakeSwitch: UISegmentedControl!

  override func viewDidLoad() {
    super.viewDidLoad()

    if let view = self.view as! SKView? {
      // Load the SKScene from 'GameScene.sks'
      if let scene = SKScene(fileNamed: "GameScene") {
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .resizeFill

        // Present the scene
        view.presentScene(scene)
      }

      view.ignoresSiblingOrder = true

      view.showsFPS = true
      view.showsNodeCount = true
    }
  }

  @IBAction func onSnakeSwith(_ sender: UISegmentedControl) {
    guard let scene = (self.view as? SKView)?.scene as? GameScene else {
      return
    }
    scene.activeSnake = sender.selectedSegmentIndex
  }

  override var shouldAutorotate: Bool {
    return true
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
        return .allButUpsideDown
    } else {
        return .all
    }
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
