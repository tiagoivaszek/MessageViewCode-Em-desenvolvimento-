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

        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = CustomColor.appLight
      
    }
    
    override func loadView() {
        
        self.screen = HomeScreen()
        self.view = self.screen
        
    }
    


}
