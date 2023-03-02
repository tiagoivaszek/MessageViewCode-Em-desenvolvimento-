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
    
}
