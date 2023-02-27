//
//  HomeViewController.swift
//  WhatsAppViewCode
//
//  Created by Ivaszek on 27/02/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    var screen: HomeScreen!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    override func loadView() {
        
        self.screen = HomeScreen()
        self.view = self.screen
        
    }
    


}
