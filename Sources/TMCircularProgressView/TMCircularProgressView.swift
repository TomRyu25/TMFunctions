//
//  TMCircularProgressView.swift
//  
//
//  Created by Tommy Ryu Tannaca on 17/05/23.
//

import Foundation
import UIKit

/**
 `CircularProgressView` is a custom UIView that displays a circular progress indicator.

 To use `CircularProgressView`, simply create an instance of the view and set the `progress` property to update the progress indicator. You can also customize the appearance of the progress indicator by setting the `trackColor`, `progressColor`, and `lineWidth` properties.

 Example usage:
 let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
 progressView.progress = 0.5
 progressView.trackColor = .gray
 progressView.progressColor = .systemGreen
 progressView.lineWidth = 10.0
 view.addSubview(progressView)
 
 - Note: By default, `CircularProgressView` is initialized with a frame of zero width and height. Make sure to set a non-zero frame before adding the view to your view hierarchy.
 
 */

public class TMCircularProgressView: UIView {
    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    private let animationDuration = 0.3
    
    var progress: CGFloat = 0.0 {
        didSet {
            setProgress(progress)
        }
    }
    
    var trackColor: UIColor = .gray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    var progressColor: UIColor = .systemGreen {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var lineWidth: CGFloat = 5.0 {
        didSet {
            trackLayer.lineWidth = lineWidth
            progressLayer.lineWidth = lineWidth
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2
        
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi / 2, endAngle: .pi * 2, clockwise: true)
        trackLayer.path = trackPath.cgPath
        
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi / 2, endAngle: .pi * 1.5 + progress * .pi * 2, clockwise: true)
        progressLayer.path = progressPath.cgPath
        
        progressLayer.strokeEnd = 0.0
    }
    
    private func setProgress(_ progress: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = progress
        animation.duration = animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressLayer.strokeEnd = progress
        progressLayer.add(animation, forKey: "animateStrokeEnd")
        
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }
    
    private func setupLayers() {
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
