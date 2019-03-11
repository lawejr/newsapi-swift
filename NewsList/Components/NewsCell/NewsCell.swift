//
//  NewsCell.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 25/12/2018.
//  Copyright © 2018 Aleksandr Kalinin. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet var previewImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentTextLabel: UILabel!
    
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var contentText = "" {
        didSet {
            contentTextLabel.text = contentText
        }
    }
    
    func configure(from model: News) {
        let url = URL(string: model.imageURL ?? "")
        
        title = model.title ?? ""
        contentText = model.text ?? ""
        previewImage.kf.setImage(with: url, placeholder: R.image.placeholder())
    }
    
}
