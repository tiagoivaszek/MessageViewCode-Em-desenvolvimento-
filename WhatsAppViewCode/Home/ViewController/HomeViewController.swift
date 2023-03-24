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
        self.configContato()
        self.addListenerRecuperarConversa()
        
    }
    
    override func loadView() {
        
        self.screen = HomeScreen()
        self.view = self.screen
        
    }
    
    private func configHomeView() {
        self.screen.navView.delegate(delegate: self)
    }
    
    private func configCollectionView() {
        self.screen.delegateCollectionView(delegate: self, dataSource: self)
    }
    
    private func configAlert() {
        self.alert = Alert(controller: self)
    }
    
    private func configIdentifierFirebase() {
        
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        
        //Recuperar id usuario logado
        
        if let currentUser = auth?.currentUser {
            self.idUsuarioLogado = currentUser.uid
            self.emailUsuarioLogado = currentUser.email
        }
        
    }
    
    private func configContato() {
        self.contato = ContatoController()
        self.contato?.delegate(delegate: self)
    }
    
    func addListenerRecuperarConversa() {
        
        if let idUsuarioLogado = auth.currentUser?.uid {
            
            self.conversasListener = firestore.collection("conversas").document(idUsuarioLogado).collection("ultimas_conversas").addSnapshotListener({ querySnapShot, error in
                
                if error == nil {
                    
                    self.listaConversa.removeAll()
                    if let snapshot = querySnapShot {
                        for document in snapshot.documents {
                            let dados = document.data()
                            self.listaConversa.append(Conversation(dicionario: dados))
                        }
                        self.screen.reloadColletionView()
                    }
                }
                
            })
            
        }
        
    }
    
    func getContato() {
        
        self.listaContact.removeAll()
        self.firestore.collection("usuarios").document(idUsuarioLogado ?? "").collection("contatos").getDocuments { snapshotResultado, error in
            
            if error != nil {
                print("erro get contato")
                return
            }
            
            if let snapshot = snapshotResultado {
                
                for document in snapshot.documents {
                    
                    let dadosContato = document.data()
                    self.listaContact.append(Contact(dicionario: dadosContato))
                    
                }
                self.screen.reloadColletionView()
                
            }
        }
        
    }
    
    
}

extension HomeViewController: navViewProtocol {
    
    func typeScreenMessagem(type: TypeConversationOrContact) {
        
        switch type {
        case .contact:
            self.screenContact = true
            self.getContato()
            self.conversasListener?.remove()
        case .conversation:
            self.screenContact = false
            self.addListenerRecuperarConversa()
            self.screen.reloadColletionView()
        }
        
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.screenContact ?? false {
            return self.listaContact.count + 1
        } else {
            return self.listaConversa.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //se for a tela de contato
        if self.screenContact ?? false {
            
            if indexPath.row == self.listaContact.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageLastCollectionViewCell.identifier, for: indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageDetailCollectionViewCell.identifier, for: indexPath) as? MessageDetailCollectionViewCell
                cell?.seuUpViewContact(contact: self.listaContact[indexPath.row])
                
                return cell ?? UICollectionViewCell()
            }
            
        } else {
            //se nao for a tela de contato
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageDetailCollectionViewCell.identifier, for: indexPath) as? MessageDetailCollectionViewCell
            cell?.seuUpViewConversation(conversation: self.listaConversa[indexPath.row])
            
            return cell ?? UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.screenContact ?? false {
            if indexPath.row == self.listaContact.count {
                self.alert?.addContact(completion: { value in
                    self.contato?.addContact(email: value, emailUsuarioLogado: self.emailUsuarioLogado ?? "", idUsuario: self.idUsuarioLogado ?? "")
                })
                
            } else {
                let VC:ChatViewController = ChatViewController()
                VC.contato = self.listaContact[indexPath.row]
                self.navigationController?.pushViewController(VC, animated: true)
            }
        } else {
            
            let VC:ChatViewController = ChatViewController()
            let dados = self.listaConversa[indexPath.row]
            let contato:Contact = Contact(id: dados.idDestinatario ?? "", nome: dados.nome ?? "")
            VC.contato = contato
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension HomeViewController:ContatoProtocol {
    
    func alertStateError(titulo: String, message: String) {
        self.alert.getAlert(titulo: titulo, mensagem: message)
    }
    
    func successContato() {
        self.alert.getAlert(titulo: "Ebaaa", mensagem: "Usuario cadastrado com sucesso") {
            self.getContato()
            
        }
    }

}
