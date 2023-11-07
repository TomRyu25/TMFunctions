//
//  TMCircularProgressView.swift
//  
//
//  Created by Tommy Ryu Tannaca on 17/05/23.
//

import Foundation
import UIKit

/**
 `TMCircularProgressView` is a custom UIView that displays a circular progress indicator.

 To use `TMCircularProgressView`, simply create an instance of the view and set the `progress` property to update the progress indicator. You can also customize the appearance of the progress indicator by setting the `trackColor`, `progressColor`, and `lineWidth` properties.

 Example usage:
 let progressView = TMCircularProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
 progressView.progress = 0.5
 progressView.trackColor = .gray
 progressView.progressColor = .systemGreen
 progressView.lineWidth = 10.0
 view.addSubview(progressView)

 - Note: By default, `TMCircularProgressView` is initialized with a frame of zero width and height. Make sure to set a non-zero frame before adding the view to your view hierarchy.
 */
public class TMCircularProgressView: UIView {
    
    internal let progressLayer = CAShapeLayer()
    internal let trackLayer = CAShapeLayer()
    internal let animationDuration = 0.3
    
    
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
        layoutInternalSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }
}
