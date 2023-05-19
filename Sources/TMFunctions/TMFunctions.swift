//
//  TMFunctions.swift
//  
//
//  Created by Tommy Ryu Tannaca on 17/05/23.
//

import Foundation
import UIKit

/// This is a utility class that provides various functions.
public class TMFunctions: UIViewController {
    
    /// Checks if a given string is not empty.
    /// - Parameter text: The string to check.
    /// - Returns: `true` if the string is not empty, otherwise `false`.
    public func stringNotEmpty(text: String?) -> Bool {
        if let unwrappedText = text, !unwrappedText.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    /// Converts an image to its Base64 representation with the specified quality.
    /// - Parameters:
    ///   - img: The image to convert.
    ///   - quality: The quality of the JPEG representation.
    /// - Returns: The Base64 encoded string representation of the image.
    public static func convertImageToBase64(img: UIImage, quality: TMJPEGQuality) -> String {
        return img.jpeg(quality)?.base64EncodedString() ?? ""
    }
    
    /// Converts a Base64 encoded string representation of an image back into a UIImage.
    /// - Parameter base64String: The Base64 encoded string representation of the image.
    /// - Returns: The UIImage instance created from the Base64 encoded string.
    public static func convertBase64ToImage(base64String: String) -> UIImage? {
        if let data = Data(base64Encoded: base64String) {
            return UIImage(data: data)
        }
        return nil
    }
    
    
    /**
     Displays a toast message on the specified view with customizations.
     
     - Parameters:
     - view: The view on which to display the toast.
     - message: The message to display in the toast.
     - duration: The duration of the toast message display in seconds. Defaults to 2.5 seconds.
     - backgroundColor: The background color of the toast. Defaults to black with alpha 0.6.
     - textColor: The text color of the toast. Defaults to white.
     - font: The font of the toast message. Defaults to system font with size 12 and semibold weight.
     - cornerRadius: The corner radius of the toast. Defaults to 15.
     */
    public static func showToast(on view: UIView, message: String, duration: TimeInterval = 2.5, backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6), textColor: UIColor = .white, font: UIFont = .systemFont(ofSize: 12, weight: .semibold), cornerRadius: CGFloat = 15) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = backgroundColor
        toastLabel.textColor = textColor
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = cornerRadius
        toastLabel.clipsToBounds = true
        
        view.addSubview(toastLabel)
        
        // Set constraints for automatic height adjustment
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        toastLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        toastLabel.setContentHuggingPriority(.required, for: .vertical)
        
        UIView.animate(withDuration: 1.5, delay: duration, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    /// Presents a preview image view controller to display a tapped image.
    ///
    /// - Parameters:
    ///   - viewController: The view controller from which to present the preview image view controller.
    ///   - tappedImage: The image that was tapped and needs to be displayed.
    public static func presentImage(from viewController: UIViewController, tappedImage: UIImage?) {
        guard let tappedImage = tappedImage else {return}
        let vc = PreviewImageVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.image = tappedImage
        
        viewController.present(vc, animated: true, completion: nil)
    }
    
    /// Creates a UIColor instance from a hexadecimal string.
    ///
    /// - Parameters:
    ///   - hexString: The hexadecimal string representing the color.
    /// - Returns: The UIColor instance created from the hexadecimal string.
    public static func uicolor(fromHexString hexString: String) -> UIColor {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    /**
     Applies a shadow effect to the view.
     
     - Parameters:
     - view: The view to apply the shadow effect to.
     - offset: The offset of the shadow from the view.
     - opacity: The opacity of the shadow.
     - radius: The radius of the shadow.
     - color: The color of the shadow.
     */
    public static func applyShadow(to views: UIView..., offset: CGSize = CGSize(width: 0, height: 0), opacity: Float = 0.5, radius: CGFloat = 4, color: UIColor = .black) {
        for view in views {
            view.layer.masksToBounds = false
            view.layer.shadowColor = color.cgColor
            view.layer.shadowOffset = offset
            view.layer.shadowOpacity = opacity
            view.layer.shadowRadius = radius
        }
    }

    /**
     Converts a `Date` object to a string representation using the specified format.
     
     - Parameters:
       - date: The `Date` object to convert.
       - format: The format string to use for the conversion.
     
     - Returns: A string representation of the `Date` object in the specified format.
    */
    public static func dateString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
