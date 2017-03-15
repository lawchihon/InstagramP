//
//  PostViewCell.swift
//  InstagramP
//
//  Created by John Law on 14/3/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit
import Parse

class PostViewCell: UITableViewCell {
    
    var post: Post!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell() {
        captionLabel.text = post.caption
        if let media = post.media {
            media.getDataInBackground(block: { (imageData, error) in
                if let imageData = imageData {
                    self.postImage.image = UIImage(data: imageData)
                }
                else {
                    print(error!.localizedDescription)
                }

            })
        }

    }
}
