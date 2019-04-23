//
//  PictoCollectionCell.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 23/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class PictoCollectionCell: UICollectionViewCell {
    
    public static let nibName: String = "PictoCollectionCell"
    public static let identifier: String = "PictoCollectionCell"
    
    @IBOutlet weak var plannedButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var isPlanned: Bool {
        return !selectedButton.isHidden
    }
    
    func setup(planned: Bool, image: UIImage?) {
        setPlanned(planned)
        self.imageView.image = image
    }
    
    func setPlanned(_ selected: Bool) {
        selectedButton.isHidden = !selected
    }
}
