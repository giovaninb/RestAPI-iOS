//
//  CommentsViewCell.swift
//  Selecao4All
//
//  Created by Giovani Nícolas Bettoni on 12/08/19.
//  Copyright © 2019 Giovani Nícolas Bettoni. All rights reserved.
//

import UIKit
import Cosmos

class CommentsViewCell: UITableViewCell {

//    let urlFoto: String
//    let nome: String
//    let nota: Int
//    let titulo, comentario: String
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var ratingBar: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
