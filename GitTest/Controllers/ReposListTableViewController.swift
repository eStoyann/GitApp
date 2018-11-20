//
//  ReposListTableViewController.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import UIKit
import CoreData

class ReposListTableViewController: UITableViewController {

    //MARK: Private struct
    private struct Storyboard {
        static let ShowDetailRepo = "Show Detail Repo"
    }
    private struct ConfigureTableView {
        var sectionName: String
        var sectionObject: [String]
    }

    //MARK: Public property
    var context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).backgoundContext
    var reposModelCopy: Repo?
    var reposModel: Repo? {
        didSet {
            self.tableView.reloadData()
        }
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(RepoTableViewCell.self)
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reposModel?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RepoTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.repoModel = reposModel?[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Storyboard.ShowDetailRepo, sender: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ident = segue.identifier {
            switch ident {
            case Storyboard.ShowDetailRepo:
                if let dest = segue.destination.content as? DetailRepoViewController,
                    let indexPath = self.tableView.indexPathForSelectedRow {
                    dest.repoModel = reposModel?[indexPath.row]
                    dest.context = context
                }
            default: break
            }
        }
    }
}
extension ReposListTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let _self = self else { return }
            let resultSearch = searchText.isEmpty ? _self.reposModelCopy : _self.reposModelCopy?.filter {
                return $0.name.range(of: searchText.lowercased(), options: .caseInsensitive) != nil
            }
            DispatchQueue.main.async {
                _self.reposModel = resultSearch
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        self.reposModel = self.reposModelCopy
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
