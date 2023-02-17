//
//  ViewController.swift
//  ViewCode
//
//  Created by Ivaszek on 06/02/23.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    var auth: Auth!
    var loginScreen: LoginScreen?
    var alert: Alert!
    
    override func loadView() {
        
        self.loginScreen = LoginScreen()
        self.view = self.loginScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.auth = Auth.auth()
        self.loginScreen?.delegate(delegate: self)
        self.loginScreen?.configTextFieldDelegate(delegate: self)
        self.alert = Alert(controller: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

}

extension LoginVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.loginScreen?.validaTextFields()
    }
    
}

extension LoginVC: LoginScreenProtocol{
    
    func actionLoginButton() {
        
        //let vc: HomeVC  = HomeVC()
        //self.navigationController?.pushViewController(vc, animated: true)
        
        guard let login = loginScreen else {return}

        self.auth.signIn(withEmail: login.getEmail(), password: login.getPassword()) { usuario, error in
            if error != nil {
                self.alert.getAlert(titulo: "Atenção", mensagem: "Dados incorretos, verifique e tente novamente")
            }else{
                if usuario == nil {
                    self.alert.getAlert(titulo: "Atenção", mensagem: "Tivemos um problema inesperado, tente novamente mais tarde")
                }else{
                    self.alert.getAlert(titulo: "Parabéns", mensagem: "Logado com sucesso!!")
                }
            }
        }
        
    }
    
    func actionRegisterButton() {
        let vc: RegisterVC = RegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

