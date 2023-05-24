//
//  TMManageQR.swift
//  
//
//  Created by Tommy Ryu Tannaca on 24/05/23.
//

import Foundation
import UIKit

public class TMScanQR{
    /// Presents a view controller for scanning QR codes.
    ///
    /// - Parameters:
    ///   - viewController: The view controller from which to present the QR code scanner.
    ///   - detectedQR: A closure that is called when a QR code is detected, providing the scanned QR code as a string parameter.
    public static func scanQR(from viewController: UIViewController, detectedQR: @escaping (String)->Void){
        guard let vc = UIStoryboard(name: "ScanQRSb", bundle: nil).instantiateViewController(withIdentifier: "ScanQRVC") as? ScanQRVC else {return}
        
        vc.detectedQR = { qrCode in
            detectedQR(qrCode)
        }
        
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true)
    }
    
    /// Creates a QR code image from the given string.
    ///
    /// - Parameter string: The string to encode as a QR code.
    /// - Returns: An optional `UIImage` containing the QR code image, or `nil` if the image creation fails.
    public static func createQR(from string: String) -> UIImage?{
        let data = string.data(using: String.Encoding.ascii)
        if let QRFilter = CIFilter(name: "CIQRCodeGenerator") {
            QRFilter.setValue(data, forKey: "inputMessage")
            
            guard let QRImage = QRFilter.outputImage else {return nil}
            
            let transformScale = CGAffineTransform(scaleX: 5.0, y: 5.0)
            let scaledQRImage = QRImage.transformed(by: transformScale)
            return UIImage(ciImage: scaledQRImage)
        }
        return nil
    }
}
