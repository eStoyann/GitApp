//
//  SearchUserViewController.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController {

    //MARK: Private struct
    private struct Storyboard {
        static let ShowReposList = "Show Repos List"
        static let ShowFavoritesRepos = "Show Favorites Repos"
    }

    //MARK: - Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var favoritesOutlet: UIBarButtonItem!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var searchBtn: UIButton! {
        didSet {
            self.searchBtn.layer.cornerRadius = 12
            self.searchBtn.layer.borderWidth = 1
            self.searchBtn.layer.borderColor = UIColor.black.cgColor
        }
    }

    //MARK: Private property
    private let queue = DispatchQueue(label: "com.gmail.response-queue", qos: .userInitiated, attributes: [.concurrent])
    private var context = (UIApplication.shared.delegate as! AppDelegate).backgoundContext
    private var textFromTextField: String { return textField.text != nil ? textField.text! : "" }
    private var error: ErrorManager? {
        didSet {
            DispatchQueue.main.async {
                if let _error = self.error {
                    let ok = UIAlertAction(title: "Done", style: .default, handler: nil)
                    self.alert(title: "Error", msg: _error.localizedDescription, actions: [ok])
                }
            }
        }
    }
    //model--------------------------
    private var reposModel: Repo? {
        didSet {
            DispatchQueue.main.async {
                if self.reposModel != nil {
                    self.performSegue(withIdentifier: Storyboard.ShowReposList, sender: nil)
                }
            }
        }
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recieveEvents()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkFavoritesBtnState()
    }

    //MARK: - Action
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBAction func favorites(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: Storyboard.ShowFavoritesRepos, sender: nil)
    }
    @IBAction func searchUser(_ sender: UIButton) {
        self.view.endEditing(true)
        NetworkingManager.shared.fetchRepos(login: textFromTextField, queue: queue) { [weak self] (result) in
            switch result {
            case let .Success(data):
                self?.reposModel = data
            case let .Failure(error):
                self?.error = error
            }
        }
    }

    //MARK: Private method
    private func checkFavoritesBtnState() {
        CoreDataManager.shared.read(entityName: "RepoCoreDataModel", context: context) { [weak self] (objects) in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                if let objects = objects as? [RepoCoreDataModel], objects.isEmpty {
                    _self.favoritesOutlet.isEnabled = false
                    _self.favoritesOutlet.tintColor = .clear
                } else {
                    _self.favoritesOutlet.isEnabled = true
                    _self.favoritesOutlet.tintColor = .black
                }
            }
        }
    }
    private func recieveEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvents(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvents(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardEvents(_ notification: Notification) {
        guard let keyboard = ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) else { return }
        if notification.name == UIResponder.keyboardWillShowNotification {
            scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height + keyboard.height / 2)
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboard.height, right: 0)
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ident = segue.identifier {
            switch ident {
            case Storyboard.ShowReposList:
                if let dest = segue.destination.content as? ReposListTableViewController {
                    dest.reposModel = reposModel
                    dest.reposModelCopy = reposModel
                    dest.context = context
                    dest.title = textFromTextField
                }
            case Storyboard.ShowFavoritesRepos:
                if let dest = segue.destination.content as? FavoritesReposTableViewController {
                    dest.context = context
                }
            default: break
            }
        }
    }
}

//MARK: extansion
extension SearchUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.textField == textField {
            self.view.endEditing(true)
            NetworkingManager.shared.fetchRepos(login: textFromTextField, queue: queue) { [weak self] (result) in
                switch result {
                case let .Success(data):
                    self?.reposModel = data
                case let .Failure(error):
                    self?.error = error
                }
            }
            return true
        }
        return false
    }
}
