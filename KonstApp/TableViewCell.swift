//
//  TableViewCell.swift
//  KonstApp
//
//  Created by Fanny Erkhammar on 2018-03-21.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK


class TableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var tableImageView: UIImageView!
    @IBOutlet weak var tabelLable: UILabel!
    @IBOutlet weak var tabelLable2: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
