//
//  InternalTMCircularProgressView.swift
//
//
//  Created by Tommy Ryu Tannaca on 07/11/23.
//

import Foundation
import UIKit

extension TMCircularProgressView {

    internal func layoutInternalSubviews() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2
        
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi / 2, endAngle: .pi * 2, clockwise: true)
        trackLayer.path = trackPath.cgPath
        
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi / 2, endAngle: .pi * 1.5 + progress * .pi * 2, clockwise: true)
        progressLayer.path = progressPath.cgPath
        
        progressLayer.strokeEnd = 0.0
    }
    
    internal func setProgress(_ progress: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = progress
        animation.duration = animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressLayer.strokeEnd = progress
        progressLayer.add(animation, forKey: "animateStrokeEnd")
        
        layoutIfNeeded()
    }
    
    internal func setupLayers() {
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        layer.addSublayer(trackLayer)
        
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        layer.addSublayer(progressLayer)
    }
}
