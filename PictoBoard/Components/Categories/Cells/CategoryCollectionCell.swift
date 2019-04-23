//
//  CategoryCollectionCell.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 19/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class CategoryCollectionCell: UICollectionViewCell {
    
    public static let nibName: String = "CategoryCollectionCell"
    public static let identifier: String = "CategoryCollectionCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(category: PictoCategory, image: UIImage?) {
        self.imageView.image = image
        self.titleLabel.text = category.name
    }
}
