//
//  ScanQRVC.swift
//  
//
//  Created by Tommy Ryu Tannaca on 24/05/23.
//

import UIKit
import AVFoundation

class ScanQRVC: UIViewController {
    
    var detectedQR: ((String) -> Void)?
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var resultLbl: UILabel!

    var captureSession = AVCaptureSession()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    var qrcodeFrameView : UIView?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOffset = .zero
        topView.layer.shadowOpacity = 0.15
        topView.layer.shadowRadius = 2
        
        setupScanQR()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    
    @IBAction func didTapBack(_ sender: Any) {
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
            view.bringSubviewToFront(titleLbl)
            view.bringSubviewToFront(backBtn)
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

extension ScanQRVC: AVCaptureMetadataOutputObjectsDelegate{
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
                resultLbl.text = "QR Scanned with value: \(String(describing: metadataObj.stringValue)). please wait"
                
                let qr = metadataObj.stringValue ?? ""
                detectedQR?(qr)
            }
        }
    }
}
