//
//  PreviewImageVC.swift
//  
//
//  Created by Tommy Ryu Tannaca on 17/05/23.
//

import Foundation
import UIKit

class PreviewImageVC: UIViewController {
    var image: UIImage?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        displayImage()
        setupGestures()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
    }
    
    private func displayImage() {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setupGestures() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        scrollView.addGestureRecognizer(pinchGesture)
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let location = gesture.location(in: imageView)
            let zoomRect = zoomRectForScale(scale: scrollView.maximumZoomScale, center: location)
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        if let view = gesture.view {
            if gesture.state == .began || gesture.state == .changed {
                let pinchCenter = CGPoint(x: gesture.location(in: view).x - view.bounds.midX,
                                          y: gesture.location(in: view).y - view.bounds.midY)
                let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                    .scaledBy(x: gesture.scale, y: gesture.scale)
                    .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
                
                let currentScale = scrollView.zoomScale
                let newScale = currentScale * gesture.scale
                if newScale < scrollView.minimumZoomScale {
                    return
                }
                
                scrollView.transform = transform
                gesture.scale = 1
            }
        }
    }
    
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        let size = CGSize(width: scrollView.bounds.size.width / scale,
                          height: scrollView.bounds.size.height / scale)
        let origin = CGPoint(x: center.x - size.width / 2,
                             y: center.y - size.height / 2)
        return CGRect(origin: origin, size: size)
    }
}

extension PreviewImageVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
