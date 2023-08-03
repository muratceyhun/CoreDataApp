//
//  CompanyCell.swift
//  CoreDataApp
//
//  Created by Murat Ceyhun Korpeoglu on 23.07.2023.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet {
            nameFoundedDateLabel.text = "\(company?.name ?? "") \(company?.numEmployees ?? "")"
            guard let imageData = company?.imageData else {return}
            companyImageView.image = UIImage(data: imageData)
            
            guard let founded = company?.founded else {return}
            guard let name = company?.name else {return}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.locale = Locale(identifier: "EN")
            let foundedDateString = dateFormatter.string(from: founded)
            let companyNameAndDate = "\(name) - Founded: \(foundedDateString)"
            nameFoundedDateLabel.text = companyNameAndDate
        }
    }
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "select_photo_empty")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Company Name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate func setupLayout() {
        
        addSubview(companyImageView)
        
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameFoundedDateLabel)
        
        nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameFoundedDateLabel.leadingAnchor.constraint(equalTo: companyImageView.trailingAnchor, constant: 8).isActive = true
        nameFoundedDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.tealColor
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
