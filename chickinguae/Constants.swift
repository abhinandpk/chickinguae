//
//  Constants.swift
//  chickinguae
//
//  Created by MacBook on 06/05/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit

class Constants: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //*********************** APIs
    
    //  https://myg.in/rest/V1/  //live
    // "http://139.59.4.255/rest/V1/"  //test
    

    let baseUrl = "https://mobileapp.chickinguae.com/index.php/api/"
    let activityIndColor:UIColor = hexStringToUIColor(hex:"#46620e")
    let imageUrl = "https://mobileapp.chickinguae.com/images/cakes/"
    let bannerUrl = "https://mobileapp.chickinguae.com/images/banners/"
    
    
    func activityIndicator() {
        
        
    }
    
    
}

/*
 
 COLORS
 
 colorPrimary">#f16826
 colorPrimaryDark">#da5a1e
 "colorAccent">#f16826
 
 "textColorPrimary">#050505
 "textColorPrimaryInverse">#ffffff
 "textColorSecondary">#4d4d4c
 
 */


//  #MARK: Extension for mobile screen sizes
//  usage: if Constants.isIPhone5()

extension Constants {
    class func isIPhone5 () -> Bool{
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 568.0
    }
    class func isIPhone6 () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 667.0
    }
    class func isIPhone6Plus () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 736.0
    }
    class func isIPad () -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
}

//  #MARK: Extension for Hex color
// usage :  var color1 = hexStringToUIColor(hex:"#d3d3d3")

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//  #MARK: Extension for loading images with main thread
// usage: cell.itemImage.imageFromServerURL(urlString: imageUrl ?? "")
/*
 extension UIImageView {
 
 func imageFromServerURL(urlString: String) {
 
 URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
 
 let status = (response as! HTTPURLResponse).statusCode
 
 if status != 200
 {
 self.image = #imageLiteral(resourceName: "grayLogo")
 
 return
 }
 
 
 if error != nil {
 return
 
 
 }
 
 
 DispatchQueue.main.async(execute: { () -> Void in
 
 let image = UIImage(data: data!)
 
 self.image = image
 
 })
 
 }).resume()
 
 }
 
 }
 */

extension UIView {
    // to add shadiow
    // usage 1 : shadowView.dropShadow()
    // usage 2 : shadowView.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

// To drop last values
// call stringname.dropLast(2) to remove last two values
//extension String {
//    func dropLast(_ n: Int = 1) -> String {
//        return String(characters.dropLast(n))
//    }
//    var dropLast: String {
//        return dropLast()
//    }
//}

// convert html to plain text
// usage : cell.detailTextLabel?.text = item.itemDescription.html2String

extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType): convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.html), convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.characterEncoding): String.Encoding.utf8.rawValue]), documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    func toDateFormattedWith(format:String)-> NSDate {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)! as NSDate
    }
}

// take characters between 2 character of sring
// usage: let sliced  = demoText.slice(from: "(", to: ")")

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringDocumentReadingOptionKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.DocumentReadingOptionKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.DocumentReadingOptionKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentAttributeKey(_ input: NSAttributedString.DocumentAttributeKey) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentType(_ input: NSAttributedString.DocumentType) -> String {
    return input.rawValue
}

