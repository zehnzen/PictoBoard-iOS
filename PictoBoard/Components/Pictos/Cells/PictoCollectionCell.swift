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
    @IBOutlet weak var nameLabel: UILabel!
    
    var isPlanned: Bool {
        return !plannedButton.isHidden
    }
    
    func setup(picto: Picto) {
        let planned = SelectedPictoStore.shared.checkIfSelected(picto: picto)
        let image = PictoCategoriesFileStore.shared.image(for: picto)
        
        setPlanned(planned)
        self.imageView.image = image
        nameLabel.text = picto.name
    }
    
    func setPlanned(_ planned: Bool) {
        plannedButton.isHidden = !planned
    }
}
