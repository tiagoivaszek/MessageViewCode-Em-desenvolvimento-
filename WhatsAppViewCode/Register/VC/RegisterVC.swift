//
//  ResgisterVC.swift
//  ViewCode
//
//  Created by Ivaszek on 06/02/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController {

    var registerScreen: RegisterScreen!
    var auth: Auth!
    var firestore: Firestore!
    var alert: Alert!
    
    override func loadView() {
        self.registerScreen = RegisterScreen()
        self.view = self.registerScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerScreen.confTextFieldDelegate(delegate: self)
        self.registerScreen.delegate(delegate: self)
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.alert = Alert(controller: self)
    }

}

extension RegisterVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //quando o teclado abaixa
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.registerScreen.validaTextFields()
    }
    
}

extension RegisterVC: RegisterScreenProtocol{
    func actionBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func actionRegisterButton() {

        guard let register = self.registerScreen else {return}
        
        self.auth.createUser(withEmail: register.getEmail(), password: register.getPassword()) { result, error in
            
            if error != nil {
                self.alert.getAlert(titulo: "Atenção", mensagem: "Erro ao cadastrar, verifique os dados e tente novamente")
            }else{
                
                //salvar dados no firestore
                
                if let idUsuario = result?.user.uid{
                    self.firestore.collection("usuarios").document(idUsuario).setData([
                        "nome": self.registerScreen.getName(),
                        "email": self.registerScreen.getEmail(),
                        "id": idUsuario
                    ])
                }
                
                self.alert.getAlert(titulo: "Parabéns", mensagem: "Usuario cadastrado com sucesso!!") {
                    self.navigationController?.popViewController(animated: true)
    }
            }
            
        }

    }
    
    
    
    
}
