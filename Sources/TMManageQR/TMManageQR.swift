//
//  TMManageQR.swift
//  
//
//  Created by Tommy Ryu Tannaca on 24/05/23.
//

import Foundation
import UIKit

public class TMScanQR{
    public static func scanQR(from viewController: UIViewController, detectedQR: @escaping (String)->Void){
        guard let vc = UIStoryboard(name: "ScanQRSb", bundle: nil).instantiateViewController(withIdentifier: "ScanQRVC") as? ScanQRVC else {return}
        
        vc.detectedQR = { qrCode in
            detectedQR(qrCode)
        }
        
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true)
    }
    
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
