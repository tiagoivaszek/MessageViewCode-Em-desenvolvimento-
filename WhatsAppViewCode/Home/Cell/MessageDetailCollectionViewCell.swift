//
//  MessageDetailCollectionViewCell.swift
//  WhatsAppViewCode
//
//  Created by Ivaszek on 27/02/23.
//

import UIKit

class MessageDetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "MessageDetailCollectionViewCell"

    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 26
        image.image = UIImage(named: "imagem-perfil")
        return image
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imageView)
        self.addSubview(self.userName)
        self.setUpContraints()
        
    }
    
    private func setUpContraints() {
        
        NSLayoutConstraint.activate([
        
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 55),
            self.imageView.heightAnchor.constraint(equalToConstant: 55),

        
            self.userName.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 15),
            self.userName.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.userName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func seuUpViewContact(contact: Contact) {
        
        self.setUserName(userName: contact.nome ?? "")
        
    }
    
    func seuUpViewConversation(conversation: Conversation) {
        
        self.setUserNameAttributedText(conversation: conversation)
        
    }
    
    func setUserName(userName: String) {
        
        _ = NSMutableAttributedString(string: userName, attributes: [NSAttributedString.Key.font : UIFont(name: CustomFont.poppinsMedium, size: 16) ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
    }
    
    func setUserNameAttributedText(conversation: Conversation) {
        
        let attributText = NSMutableAttributedString(string: "\(conversation.nome ?? "")", attributes: [NSAttributedString.Key.font : UIFont(name: CustomFont.poppinsMedium, size: 16) ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        attributText.append(NSMutableAttributedString(string: "\n\(conversation.ultimaMensagem ?? "")", attributes: [NSAttributedString.Key.font : UIFont(name: CustomFont.poppinsMedium, size: 14) ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
    }
    
}
