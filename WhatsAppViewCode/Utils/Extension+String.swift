//
//  Extension+String.swift
//  WhatsAppViewCode
//
//  Created by Ivaszek on 17/02/23.
//

import UIKit

extension String {
    
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font : font])
    }
    
    func heighWithContrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        
        let constrainRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boudingBox = self.boundingRect(with: constrainRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil)
        return boudingBox.height
        
    }
}
