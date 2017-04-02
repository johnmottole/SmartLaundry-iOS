//
//  LoadingCircle.swift
//  Laundry
//
//  Created by John Mottole on 3/13/17.
//  Copyright © 2017 John Mottole. All rights reserved.
//

import UIKit

class LoadingCircle: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    let rectShape = CAShapeLayer()
    var canDraw = false
    let label = UILabel()
    override func draw(_ rect: CGRect) {
            label.text = "Start"
        
            let bounds = rect
            
            // Create CAShapeLayerS
            rectShape.bounds = bounds
            rectShape.position.x = rect.midX
            rectShape.position.y = rect.midY
            
            rectShape.cornerRadius = bounds.width / 2
            self.layer.addSublayer(rectShape)
            
            rectShape.path = UIBezierPath(ovalIn: rectShape.bounds).cgPath
            
            rectShape.lineWidth = 4.0
            rectShape.strokeColor = UIColor.clear.cgColor
            rectShape.fillColor = UIColor.orange.cgColor
        if canDraw {
            rectShape.strokeColor = UIColor.blue.cgColor
            rectShape.strokeStart = 0
            rectShape.strokeEnd = 0.5
            
            let start = CABasicAnimation(keyPath: "strokeStart")
            start.toValue = 1
            let end = CABasicAnimation(keyPath: "strokeEnd")
            end.toValue = 1
            
            let group = CAAnimationGroup()
            group.animations = [start, end]
            group.duration = 1.5
            group.autoreverses = true
            group.repeatCount = HUGE // repeat forver
            rectShape.add(group, forKey: nil)

        }
        self.bringSubview(toFront: label)

    }
 

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = CGRect(x: 0, y: 0, width: self.bounds.width/2, height: 20)
        label.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        label.textAlignment = .center
        self.addSubview(label)

    }
    
    public func startAnimation()
    {
        canDraw = true
        self.draw(self.bounds)
    }
    public func stopAnimation()
    {
        rectShape.removeAllAnimations()
        rectShape.removeFromSuperlayer()
        canDraw = false
        self.draw(self.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

}
