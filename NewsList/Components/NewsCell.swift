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
            if (title != oldValue) {
                titleLabel.text = title
            }
        }
    }
    
    var contentText = "" {
        didSet {
            if (contentText != oldValue) {
                contentTextLabel.text = contentText
            }
        }
    }
    
}
