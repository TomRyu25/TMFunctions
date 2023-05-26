//
//  ScanQRViewController.swift
//
//
//  Created by Tommy Ryu Tannaca on 24/05/23.
//

import UIKit
import AVFoundation

class ScanQRViewController: UIViewController {
    
    var detectedQR: ((String) -> Void)?
    
    var topView: UIView!
    var titleLbl: UILabel!
    var backBtn: UIButton!
    var botView: UIView!
    var resultLbl: UILabel!

    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    var qrcodeFrameView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupScanQR()
    }
    private func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        
        // Top View
        topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = .white
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOffset = .zero
        topView.layer.shadowOpacity = 0.15
        topView.layer.shadowRadius = 2
        view.addSubview(topView)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
        
        // Title Label
        titleLbl = UILabel()
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.text = "Scan QR"
        titleLbl.textAlignment = .center
        titleLbl.textColor = .black
        titleLbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        topView.addSubview(titleLbl)
        
        NSLayoutConstraint.activate([
            titleLbl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16)
        ])
        
        // Back Button
        backBtn = UIButton(type: .system)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.setTitle("Back", for: .normal)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        backBtn.addTarget(self, action: #selector(didTapBack(_:)), for: .touchUpInside)
        topView.addSubview(backBtn)
        
        NSLayoutConstraint.activate([
            backBtn.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            backBtn.centerYAnchor.constraint(equalTo: titleLbl.centerYAnchor)
        ])
        
        // Bottom View
        botView = UIView()
        botView.translatesAutoresizingMaskIntoConstraints = false
        botView.backgroundColor = .white
        view.addSubview(botView)
        
        NSLayoutConstraint.activate([
            botView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2, constant: -43),
            botView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            botView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            botView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Result Label
        resultLbl = UILabel()
        resultLbl.text = "Point the camera at the QR Code"
        resultLbl.translatesAutoresizingMaskIntoConstraints = false
        resultLbl.textAlignment = .center
        resultLbl.textColor = .lightGray
        resultLbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        resultLbl.numberOfLines = 4
        botView.addSubview(resultLbl)
        
        NSLayoutConstraint.activate([
            resultLbl.centerXAnchor.constraint(equalTo: botView.centerXAnchor),
            resultLbl.centerYAnchor.constraint(equalTo: botView.centerYAnchor),
            resultLbl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    
    @objc func didTapBack(_ sender: UIButton) {
        dismiss(animated: false)
    }

    private func setupScanQR(){
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            resultLbl.text = "Failed to get camera device"
            return
        }
        
        do{
            // Get an instance of the AVCaptureDeviceInput class using previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on capture seesion
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Initialize the video preview layer and add it as sublayer to the viewPreview layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer)
            
            // start video capture
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession.startRunning()
            }
            
            //Move top view and botom view to front
            view.bringSubviewToFront(topView)
            view.bringSubviewToFront(botView)
            
            // Initialize QR Code frame to highlight the QR Code
            
            qrcodeFrameView = UIView()
            
            if let qrcodeFrameView = qrcodeFrameView {
                qrcodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrcodeFrameView.layer.borderWidth = 4
                view.addSubview(qrcodeFrameView)
                view.bringSubviewToFront(qrcodeFrameView)
            }
            
        }
        catch{
            // if fail print error out and dont continue
            resultLbl.text = error.localizedDescription
            return
        }
    }
}

extension ScanQRViewController: AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrcodeFrameView?.frame = .zero
            resultLbl.text = "Point the camera at the QR Code"
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR Code metadata then update label and set bounds
            let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: metadataObj)
            qrcodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                let qr = metadataObj.stringValue ?? ""
                resultLbl.text = "\(qr)\n\nplease wait"
                
                dismiss(animated: true){ [weak self] in
                    self?.detectedQR?(qr)
                }
            }
        }
    }
}
