//
//  NavView.swift
//  WhatsAppViewCode
//
//  Created by Ivaszek on 27/02/23.
//

import UIKit

enum TypeConversationOrContact {
    case conversation
    case contact
}

protocol navViewProtocol: AnyObject {
    func  typeScreenMessagem(type: TypeConversationOrContact)
}

class NavView: UIView {
    
    weak private var delegate: navViewProtocol?
    
    func delegate(delegate: navViewProtocol) {
        self.delegate = delegate
    }

    lazy var navBackGroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 35
        view.layer.maskedCorners = [.layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.02).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 10
        return view
    }()
    
    lazy var navBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = .gray
        searchBar.searchTextField.borderStyle = .none
        searchBar.placeholder = "Digite aqui"
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 20
        return searchBar
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    lazy var conversationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName:"message")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemPink
        button.addTarget(self, action: #selector(self.tappedConversationButton), for: .touchUpInside)
        return button
    }()
    
    lazy var contactButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "group")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(self.tappedContactButton), for: .touchUpInside)
        return button
    }()
    
    @objc func tappedConversationButton() {
        self.delegate?.typeScreenMessagem(type: .conversation)
        self.conversationButton.tintColor = .systemPink
        self.contactButton.tintColor = .black
    }
    @objc func tappedContactButton() {
        self.delegate?.typeScreenMessagem(type: .contact)
        self.conversationButton.tintColor = .black
        self.contactButton.tintColor = .systemPink
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addElemented()
        self.setUpContrainsts()
        
    }
    
    private func addElemented() {
        self.addSubview(self.navBackGroundView)
        self.navBackGroundView.addSubview(navBar)
        self.navBar.addSubview(self.searchBar)
        self.navBar.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.conversationButton)
        self.stackView.addArrangedSubview(self.contactButton)
        

    }
    
    private func setUpContrainsts() {
        NSLayoutConstraint.activate([
            
            self.navBackGroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navBackGroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.navBackGroundView.topAnchor.constraint(equalTo: self.topAnchor),
            self.navBackGroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            
            self.navBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.navBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.navBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navBar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            
            self.searchBar.leadingAnchor.constraint(equalTo: self.navBar.leadingAnchor, constant: 20),
            self.searchBar.centerYAnchor.constraint(equalTo: self.navBar.centerYAnchor),
            self.searchBar.trailingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: -20),
            self.searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            
            self.stackView.trailingAnchor.constraint(equalTo: self.navBar.trailingAnchor, constant: -30),
            self.stackView.centerYAnchor.constraint(equalTo: self.navBar.centerYAnchor),
            self.stackView.widthAnchor.constraint(equalToConstant: 100),
            self.stackView.heightAnchor.constraint(equalToConstant: 30),
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
