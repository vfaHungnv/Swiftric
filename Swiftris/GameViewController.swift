//
//  GameViewController.swift
//  HuCaTetris
//
//  Created by HungNV on 6/23/17.
//  Copyright © 2017 HungNV. All rights reserved.
//

import UIKit
import SpriteKit
import Firebase

class GameViewController: UIViewController, SwiftrisDelegate {

    var scene: GameScene!
    var swiftris:Swiftris!
    
    // #1
    var panPointReference: CGPoint?
    @IBOutlet weak var vScore: UIView!
    @IBOutlet weak var vLevel: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // #13
        scene.tick = didTick
        
        swiftris = Swiftris()
        swiftris.delegate = self
        swiftris.beginGame()
        
        // Present the scene.
        skView.presentScene(scene)
        self.setupView()
    }
    
    func setupView() {
        self.vScore.mCustomView(5.0)
        self.vLevel.mCustomView(5.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = true
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func didTick(_ sender: UITapGestureRecognizer) {
        swiftris.rotateShape()
    }
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        // #2
        let currentPoint = sender.translation(in: self.view)
        if let originalPoint = panPointReference {
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                if sender.velocity(in: self.view).x > CGFloat(0) {
                    swiftris.moveShapeRight()
                } else {
                    swiftris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .began {
            panPointReference = currentPoint
        }
    }
    
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
        swiftris.dropShape()
    }
    
    // #15
    func didTick() {
        // #15
        swiftris.letShapeFall()
    }
    
    func nextShape() {
        let newShapes = swiftris.newShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
        self.scene.movePreviewShape(fallingShape) {
            // #16
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
    }
    
    func gameDidBegin(_ swiftris: Swiftris) {
        lblLevel.text = "\(swiftris.level)"
        lblScore.text = "\(swiftris.score)"
        scene.tickLengthMillis = TickLengthLevelOne
        
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(_ swiftris: Swiftris) {
        view.isUserInteractionEnabled = false
        scene.stopTicking()
        
        scene.playSound("gameover.mp3")
        scene.animateCollapsingLines(swiftris.removeAllBlocks(), fallenBlocks: swiftris.removeAllBlocks()) { 
            swiftris.beginGame()
        }
    }
    
    func gameDidLevelUp(_ swiftris: Swiftris) {
        lblLevel.text = "\(swiftris.level)"
        if scene.tickLengthMillis >= 100 {
            scene.tickLengthMillis -= 100
        } else if scene.tickLengthMillis > 50 {
            scene.tickLengthMillis -= 50
        }
        scene.playSound("levelup.mp3")
    }
    
    func gameShapeDidDrop(_ swiftris: Swiftris) {
        scene.redrawShape(swiftris.fallingShape!) {
            swiftris.letShapeFall()
        }
        scene.playSound("drop.mp3")
    }
    
    func gameShapeDidLand(_ swiftris: Swiftris) {
        scene.stopTicking()
        self.view.isUserInteractionEnabled = false
        
        // #10
        let removeLines = swiftris.removeCompletedLines()
        if removeLines.linesRemoved.count > 0 {
            self.lblScore.text = "\(swiftris.score)"
            scene.animateCollapsingLines(removeLines.linesRemoved, fallenBlocks: removeLines.linesRemoved, completion: { 
                // #11
                self.gameShapeDidLand(swiftris)
            })
            scene.playSound("bomb.mp3")
        } else {
            nextShape()
        }
    }
    
    // #17
    func gameShapeDidMove(_ swiftris: Swiftris) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }
}

//MARK:- UIGestureRecognizer
extension GameViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        
        return false
    }
}
