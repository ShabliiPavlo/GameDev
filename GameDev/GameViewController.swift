//
//  GameViewController.swift
//  GameDev
//
//  Created by Pavel Shabliy on 01.11.2024.
//

import SpriteKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        setupButtons()
    }
    
    private func setupButtons() {
        let plusButton = UIButton(frame: CGRect(x: self.view.frame.width - 80, y: self.view.frame.height - 80, width: 60, height: 60))
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.white, for: .normal)
        plusButton.backgroundColor = .blue
        plusButton.layer.cornerRadius = 30
        plusButton.addTarget(self, action: #selector(increaseCircleSize), for: .touchUpInside)
        self.view.addSubview(plusButton)
        
        let minusButton = UIButton(frame: CGRect(x: 20, y: self.view.frame.height - 80, width: 60, height: 60))
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.white, for: .normal)
        minusButton.backgroundColor = .red
        minusButton.layer.cornerRadius = 30 
        minusButton.addTarget(self, action: #selector(decreaseCircleSize), for: .touchUpInside)
        self.view.addSubview(minusButton)
    }
    
    @objc private func increaseCircleSize() {
        if let scene = (self.view as? SKView)?.scene as? GameScene {
            scene.increaseCircleSize()
        }
    }
    
    @objc private func decreaseCircleSize() {
        if let scene = (self.view as? SKView)?.scene as? GameScene {
            scene.decreaseCircleSize()
        }
    }
}

