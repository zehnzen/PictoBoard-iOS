//
//  TaskPictoCollectionCell.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 25/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class TaskPictoCollectionCell: UICollectionViewCell {
    
    public static let nibName: String = "TaskPictoCollectionCell"
    public static let identifier: String = "TaskPictoCollectionCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setup(image: UIImage?) {
        self.imageView.image = image
    }
}
