//
//  HomeViewController.swift
//  WhatsAppViewCode
//
//  Created by Ivaszek on 27/02/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    var screen: HomeScreen!
    var auth: Auth!
    var firestore: Firestore!
    
    var idUsuarioLogado: String?
    var emailUsuarioLogadp: String?
    var alert: Alert!
    var screenContact: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = CustomColor.appLight
        self.configHomeView()
        self.configCollectionView()
        self.configAlert()
              
    }
    
    override func loadView() {
        
        self.screen = HomeScreen()
        self.view = self.screen
        
    }
    
    private func configHomeView(){
        self.screen.navView.delegate(delegate: self)
    }
    
    private func configCollectionView(){
        self.screen.delegateCollectionView(delegate: self, dataSource: self)
    }
    
    private func configAlert(){
        self.alert = Alert(controller: self)
    }
    
    
}

extension HomeViewController: navViewProtocol{
    
    func typeScreenMessagem(type: TypeConversationOrContact) {
        
        switch type {
        case .contact:
            self.screenContact = true
        case .conversation:
            self.screenContact = false
        }
        
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
