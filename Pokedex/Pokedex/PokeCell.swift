//
//  PokeCell.swift
//  Pokedex
//
//  Created by Harrison Resnick on 2/27/21.
//

import Foundation
import UIKit

class PokeCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: PokeCell.self)
    
    var cellContents: Pokemon? {
        didSet {
            
            let completion: (UIImage)->Void = { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let url: URL = URL(string: self.cellContents!.imageUrl) {
                    if let image = try? Data(contentsOf: url) {
                        //self.imageView.image = UIImage(data: image)
                        completion(UIImage(data: image)!)
                    }
                }
            }

            infoView.text = "\((cellContents?.name)!): \((cellContents?.id)!)"
            
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let infoView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        contentView.backgroundColor = .cyan
        
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        contentView.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2.5),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2.5),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
