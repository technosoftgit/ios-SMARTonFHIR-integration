//
//  ProviderListCellTableViewCell.swift

//
//  Created by Zain Arshad on 17/04/2019.
//  Copyright © 2019 Technosoft Solutions. All rights reserved.
//

import UIKit

class ProviderListCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    func displayContent(name: String, url: String){
        self.nameLabel.text=name
        self.urlLabel.text=url
    }

}
