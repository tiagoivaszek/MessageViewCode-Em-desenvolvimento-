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
    var emailUsuarioLogado: String?
    var alert: Alert!
    var screenContact: Bool?
    
    var contato: ContatoController?
    var listaContact:[Contact] = []
    var listaConversa:[Conversation] = []
    var conversasListener: ListenerRegistration?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = CustomColor.appLight
        self.configHomeView()
        self.configCollectionView()
        self.configAlert()
        self.configIdentifierFirebase()
        
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
    
    private func configIdentifierFirebase(){
        
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        
        //Recuperar id usuario logado
        
        if let currentUser = auth?.currentUser{
            self.idUsuarioLogado = currentUser.uid
            self.emailUsuarioLogado = currentUser.email
        }
        
    }
    
    private func configContato(){
        self.contato = ContatoController()
        self.contato?.delegate(delegate: self)
    }
    
    func addListenerRecuperarConversa(){
        
        
        
    }
    
    func getContato(){
        
        self.listaContact.removeAll()
        self.firestore.collection("usuarios").document(idUsuarioLogado ?? "").collection("contatos").getDocuments { snapshotResultado, error in
            
            if error != nil{
                print("erro get contato")
                return
            }
            
            if let snapshot = snapshotResultado{
                
                for document in snapshot.documents{
                    
                    let dadosContato = document.data()
                    self.listaContact.append(Contact(dicionario: dadosContato))
                    
                }
                self.screen.reloadColletionView()
                
            }
        }
        
    }
    
    
}

extension HomeViewController: navViewProtocol{
    
    func typeScreenMessagem(type: TypeConversationOrContact) {
        
        switch type {
        case .contact:
            self.screenContact = true
            self.getContato()
        case .conversation:
            self.screenContact = false
            //to do recuperar conversas
            self.screen.reloadColletionView()
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

extension HomeViewController:ContatoProtocol{
    
    func alertStateError(titulo: String, message: String) {
        self.alert.getAlert(titulo: titulo, mensagem: message)
    }
    
    func successContato() {
        self.alert.getAlert(titulo: "Ebaaa", mensagem: "Usuario cadastrado com sucesso") {
            self.getContato()
            
        }
    }

}
