//
//  AnnouncementTableCell.swift
//  plantation-park-heights
//
//  Created by Baker, Abbey on 8/6/19.
//  Copyright © 2019 Ortuno Marroquin, Eduardo. All rights reserved.
//

import Foundation
import UIKit

class AnnouncementTableCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var reputationContainerView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reputationContainerView.backgroundColor = .lightGray
        reputationContainerView.layer.cornerRadius = 6
        
        indicatorView.color = ColorPalette.RWGreen
    }
    
    func configure(with moderator: Moderator?) {
        if let moderator = moderator {
            displayNameLabel?.text = moderator.displayName
            reputationLabel?.text = moderator.reputation
            displayNameLabel.alpha = 1
            reputationContainerView.alpha = 1
        } else {
            displayNameLabel.alpha = 0
            reputationContainerView.alpha = 0
        }
    }
}
