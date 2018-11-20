//
//  DetailRepoViewController.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import UIKit
import CoreData

class DetailRepoViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var titleRepo: UILabel!
    @IBOutlet private weak var descriptionRepo: UILabel!
    @IBOutlet private weak var languageRepo: UILabel!
    @IBOutlet private weak var starsRepo: UILabel!
    @IBOutlet private weak var watchersRepo: UILabel!
    @IBOutlet private weak var forksRepo: UILabel!
    @IBOutlet private weak var createdRepo: UILabel!
    @IBOutlet private weak var updatedRepo: UILabel!
    @IBOutlet private weak var pushedRepo: UILabel!
    @IBOutlet private weak var addToDBBtnOutlt: UIBarButtonItem!

    //MARK: Private property
    private var objectInDBis = false {
        didSet {
            self.addToDBBtnOutlt.title = objectInDBis ? "-" : "+"
        }
    }

    //MARK: Public property
    var repoModel: RepoElement? {
        didSet {
            checkRepoInDB()
            configureUI()
        }
    }
    var context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).backgoundContext {
        didSet {
            checkRepoInDB()
        }
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    //MARK: - Action
    @IBAction func addToDBBtn(_ sender: UIBarButtonItem) {
        if let repo = repoModel, let context = self.context {
            if objectInDBis {
                CoreDataManager.shared.delete(objects: [repo], context: context) { [weak self] in
                    guard let _self = self else { return }
                    _self.checkRepoInDB()
                }
            } else {
                CoreDataManager.shared.create(objects: [repo], context: context) { [weak self] in
                    guard let _self = self else { return }
                    _self.checkRepoInDB()
                }
            }
        }
    }

    //MARK: Private method
    private func configureUI() {
        self.titleRepo?.text = repoModel?.name ?? "No Name"
        self.descriptionRepo?.text = repoModel?.description ?? "No description"
        self.languageRepo?.text = repoModel?.language ?? "No language"
        self.starsRepo?.text = numberFormatter.string(from: NSNumber(value: repoModel?.watchers ?? 0))
        self.watchersRepo?.text = numberFormatter.string(from: NSNumber(value: repoModel?.watchers ?? 0))
        self.forksRepo?.text = numberFormatter.string(from: NSNumber(value: repoModel?.forks ?? 0))
        self.createdRepo?.text = dateFormatter.string(from: repoModel?.created ?? Date())
        self.updatedRepo?.text = dateFormatter.string(from: repoModel?.updated ?? Date())
        self.pushedRepo?.text = dateFormatter.string(from: repoModel?.pushed ?? Date())
    }
    private func checkRepoInDB() {
        guard let repo = self.repoModel, let context = self.context else { return }
        CoreDataManager.shared.find(objects: [repo], context: context) { [weak self] (data) in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                _self.objectInDBis = !data.isEmpty
            }
        }
    }
}
