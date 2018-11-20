//
//  FavoritesReposTableViewController.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import UIKit
import CoreData

class FavoritesReposTableViewController: FetchedResultTableViewController {

    //MARK: Private struct
    private struct Storyboard {
        static let ShowDetailRepo = "Show Detail Repo"
    }

    //MARK: - Outlets
    @IBOutlet private weak var searchBar: UISearchBar! 
    @IBOutlet private weak var trashBtnOutlet: UIBarButtonItem!

    //MARK: Private property
    private var fetchResultController: NSFetchedResultsController<RepoCoreDataModel>?

    //MARK: Public Property
    var context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).backgoundContext {
        didSet {
            fetchRepos(searchText: nil)
        }
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(RepoTableViewCell.self)
        self.tableView.tableFooterView = UIView()
        self.tableView.sectionIndexColor = .black
    }

    //MARK: - Action
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func trash(_ sender: UIBarButtonItem) {
        changeStateEditBtn()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultController?.sections?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RepoTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let object = fetchResultController?.object(at: indexPath) {
            var model: RepoElement? = nil
            object.managedObjectContext?.performAndWait {
                            model = RepoElement(object: object)
            }
            cell.repoModel = model
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchResultController?.sections, sections.count > 0 {
            return sections[section].name
        } else {
            return nil
        }
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchResultController?.sectionIndexTitles
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchResultController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        if !self.tableView.isEditing {
            performSegue(withIdentifier: Storyboard.ShowDetailRepo, sender: cell)
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let object = fetchResultController?.object(at: indexPath),
                let context = context?.parent {
                let repo = RepoElement(object: object)
                CoreDataManager.shared.delete(objects: [repo], context: context) {
                    DispatchQueue.main.async {
                        self.changeStateEditBtn()
                        self.fetchRepos(searchText: nil)
                    }
                }
            }
        }
    }

    //MARK: Private method
    private func fetchRepos(searchText: String?) {
        if let context = context?.parent {
            let request: NSFetchRequest<RepoCoreDataModel> = NSFetchRequest(entityName: "RepoCoreDataModel")
            request.predicate = searchText != nil && !searchText!.isEmpty ? NSPredicate(format: "name contains[c] %@", searchText!) : nil
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
            self.fetchResultController = NSFetchedResultsController<RepoCoreDataModel>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: "name.firstLetter",
                cacheName: nil)
        }
        self.fetchResultController?.delegate = self
        try? self.fetchResultController?.performFetch()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    private func changeStateEditBtn() {
        self.view.endEditing(true)
        searchBar.text = nil
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        self.trashBtnOutlet.title = self.tableView.isEditing ? "Done" : "Edit"
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.ShowDetailRepo:
                if let dest = segue.destination.content as? DetailRepoViewController,
                    let cell = sender as? UITableViewCell,
                    let indexPath = self.tableView.indexPath(for: cell),
                    let object = fetchResultController?.object(at: indexPath) {
                    dest.repoModel = RepoElement(object: object)
                }
            default: break
            }
        }
    }
}
extension FavoritesReposTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchRepos(searchText: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        fetchRepos(searchText: nil)
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
