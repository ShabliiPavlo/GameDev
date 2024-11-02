//
//  GameScene.swift
//  GameDev
//
//  Created by Pavel Shabliy on 01.11.2024.

import SpriteKit

class GameScene: SKScene {
    var circle: SKShapeNode!
    var indicatorLine: SKShapeNode!
    var collisionCount = 0
    var alertShown = false
    var lastCollisionNode: SKNode?
    var collisionLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        backgroundColor = .white

        circle = SKShapeNode(circleOfRadius: 50)
        circle.position = CGPoint(x: frame.midX, y: frame.midY)
        circle.fillColor = .blue
        addChild(circle)

        indicatorLine = SKShapeNode(rectOf: CGSize(width: 5, height: 100))
        indicatorLine.position = CGPoint(x: 0, y: 0)
        indicatorLine.fillColor = .white
        circle.addChild(indicatorLine)

        let rotateAction = SKAction.rotate(byAngle: -CGFloat.pi * 2, duration: 2)
        let repeatRotation = SKAction.repeatForever(rotateAction)
        circle.run(repeatRotation)

        collisionLabel = SKLabelNode(text: "Удари: 0")
        collisionLabel.fontSize = 24
        collisionLabel.fontColor = .black
        collisionLabel.position = CGPoint(x: frame.midX, y: frame.height - 80)
        addChild(collisionLabel)

        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(createObstacle),
            SKAction.wait(forDuration: 2.0)
        ])))
    }

    private func createObstacle() {
        
        let minY = CGFloat(100)
        let maxY = frame.height - 120

        let randomY = CGFloat.random(in: minY...maxY)
        let obstacle = createLine(at: CGPoint(x: -200, y: randomY))

        addChild(obstacle)

        let moveRight = SKAction.moveBy(x: frame.width + 400, y: 0, duration: 4.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveRight, remove])
        obstacle.run(sequence)
    }

    private func createLine(at position: CGPoint) -> SKShapeNode {
        let line = SKShapeNode(rectOf: CGSize(width: 200, height: 10))
        line.position = position
        line.fillColor = .black
        return line
    }
    
    private func isCollisionBetween(circle: SKShapeNode, obstacle: SKShapeNode) -> Bool {
        
        let distance = hypot(circle.position.x - obstacle.position.x, circle.position.y - obstacle.position.y)
        let circleRadius = circle.frame.width / 2.6
        let obstacleHeight = obstacle.frame.height / 2.6
        
        return distance < (circleRadius + obstacleHeight)
    }


    override func update(_ currentTime: TimeInterval) {
        if !alertShown {
            if let obstacleNodes = children.filter({ $0 is SKShapeNode && $0 != circle && $0 != indicatorLine }) as? [SKShapeNode] {
                for obstacle in obstacleNodes {
                    if isCollisionBetween(circle: circle, obstacle: obstacle) && lastCollisionNode !== obstacle {
                        collisionCount += 1
                        lastCollisionNode = obstacle
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

                        collisionLabel.text = "Удари: \(collisionCount)"

                        if collisionCount >= 5 {
                            showAlert()
                            alertShown = true
                            break
                        }
                    }
                }
            }
        }
    }

    private func showAlert() {
        let alert = UIAlertController(title: "Попередження", message: "Ви отримали 5 ударів, перезапустити гру?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.resetGame()
        }))
        view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    private func resetGame() {
        circle.position = CGPoint(x: frame.midX, y: frame.midY)
        circle.xScale = 1.0
        circle.yScale = 1.0
        collisionCount = 0
        alertShown = false
        lastCollisionNode = nil

        collisionLabel.text = "Удари: 0"
    }

    func increaseCircleSize() {
        if circle.xScale < 2.0 {
            circle.xScale += 0.1
            circle.yScale += 0.1
        }
    }

    func decreaseCircleSize() {
        if circle.xScale > 0.5 {
            circle.xScale -= 0.1
            circle.yScale -= 0.1
        }
    }
}


