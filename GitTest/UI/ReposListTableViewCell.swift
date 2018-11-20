//
//  ReposListTableViewCell.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import UIKit

class ReposListTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet private weak var nameRepo: UILabel!
    @IBOutlet private weak var starsRate: UILabel!

    //MARK: Public property
    var repoModel: RepoElement? {
        didSet {
            configureUI()
        }
    }

    //MARK: Private method
    private func configureUI() {
        self.nameRepo?.text = repoModel?.name ?? ""
        self.starsRate?.text = numberFormatter.string(from: NSNumber(value: repoModel?.watchers ?? 0))
    }
}
