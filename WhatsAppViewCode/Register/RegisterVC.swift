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
                
                let erroR = error! as NSError
                
                if let codigoErro = erroR.userInfo["FIRAuthErrorUserInfoNameKey"]{
                    
                    let erroTexto = codigoErro as! String
                    var mensagemErro = ""
                    
                    switch erroTexto {
                        
                    case "ERROR_INVALID_EMAIL" : mensagemErro = "E-mail inválido, digite um e-mail válido!"
                        break
                    case "ERROR_WEAK_PASSWORD" : mensagemErro = "A senha precisa ter no mínimo 6 caracteres, com letras e números."
                        break
                    case "ERROR_EMAIL_ALREADY_IN_USE": mensagemErro = "Esse e-mail já está sendo utilizado, crie sua conta com outro e-mail."
                        break
                    default: mensagemErro = "Dados digitados incorretos"
                    }
                    
                    self.alert.getAlert(titulo: "Atenção", mensagem: mensagemErro)
                }
                
            }else{
                
                //salvar dados no firestore
                
                if let idUsuario = result?.user.uid{
                    self.firestore.collection("usuarios").document(idUsuario).setData([
                        "nome": self.registerScreen.getName(),
                        "email": self.registerScreen.getEmail(),
                        "id": idUsuario
                    ])
                }
                
            }
            
            let vc = HomeViewController()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
            
        }
        
        
        
    }
    
}

    

