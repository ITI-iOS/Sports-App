//
//  CustomLeagueTCell.swift
//  Sports App
//
//  Created by Adham Samer on 21/01/2023.
//

import UIKit

class CustomLeagueTCell: UITableViewCell {

    @IBOutlet weak var leagueImage: UIImageView!
    
    @IBOutlet weak var leagelLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var videoBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
