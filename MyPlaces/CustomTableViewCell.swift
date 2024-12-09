//
//  CustomTableViewCell.swift
//  MyPlaces
//
//  Created by Visarg on 03.11.2024.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlase: UIImageView! {
        didSet{
            imageOfPlase?.layer.cornerRadius = imageOfPlase.frame.size.height / 2
            imageOfPlase?.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lacationLabel: UILabel!
    @IBOutlet weak var tybeLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
        cosmosView.settings.starSize = 15
        cosmosView.settings.filledImage = UIImage(named: "filledStar")
        cosmosView.settings.emptyImage = UIImage(named: "emptyStar")
        cosmosView.settings.updateOnTouch = false
        }
    }
    
    
    //MARK: Setting cosmosView
    
    
}
