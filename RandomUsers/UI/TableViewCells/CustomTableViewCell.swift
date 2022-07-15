//
//  CustomTableViewCell.swift
//  RandomUsers
//
//  Created by Elaine Herrera on 15/7/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    static let height: CGFloat = 80
    private let imageHeight: CGFloat = 48
    private let padding: CGFloat = 16
    private let spacing: CGFloat = 6
    
    var dataTask: URLSessionDataTask?
    
    private lazy var profileImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = imageHeight / 2
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel:UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = spacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    func setUpView(){
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(stackView)
        
        let imageViewConstrains = [
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            profileImageView.widthAnchor.constraint(equalToConstant: imageHeight),
            profileImageView.heightAnchor.constraint(equalToConstant: imageHeight)
        ]
        
        NSLayoutConstraint.activate(imageViewConstrains)
        
        let stackViewConstraints = [
            stackView.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints)
    }
    
    func configure(user: User?){
        nameLabel.text = user?.fullName()
        emailLabel.text = user?.email
        
        //TODO: Cache image download
        guard let thumbnail = user?.picture?.thumbnail else {
            profileImageView.image = UIImage(systemName: "person.circle")
            return
        }
        let url = URL(string: thumbnail)
        
        dataTask = URLSession.shared.dataTask(with: url!) { [weak self] (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    self?.profileImageView.image = UIImage(data: data)
                }
            }
        }
        dataTask?.resume()
    }
}
