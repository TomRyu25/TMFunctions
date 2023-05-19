//
//  ListExtension.swift
//  
//
//  Created by Tommy Ryu Tannaca on 17/05/23.
//

import Foundation
import UIKit

extension UIImage{
    func jpeg(_ jpegQuality: TMJPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
