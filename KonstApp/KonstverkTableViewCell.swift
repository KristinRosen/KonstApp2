//
//  KonstverkTableViewCell.swift
//  KonstApp
//
//  Created by Fanny Erkhammar on 2018-03-20.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit

class KonstverkTableViewCell: UITableViewCell {

    var bildUrl = String()
    
    //MARK: Properties
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
