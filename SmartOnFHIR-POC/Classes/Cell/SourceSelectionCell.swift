//
//  SourceSelectionCell.swift
//
//  Created by Zain Arshad on 28/01/2019.
//  Copyright © 2019 Technosoft Solutions. All rights reserved.
//

import UIKit

class SourceSelectionCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    func displayContent(icon: UIImage, name: String){
        self.icon.image=icon
        self.name.text=name
    }
}
