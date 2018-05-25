//
//  WordsCountViewController.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import UIKit

protocol WordsCountViewInput: ActivityShowable {
    func reloadTable()
    func makeNavigationButtonEnable()
}

class WordsCountViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    weak var activityIndicator: UIView?
    
    var presenter: WordsCountViewOutput!

    //MARK: - Life Cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        presenter = WordsCountPresenter(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewIsReady()
    }
    
    //MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TextViewController {
            vc.text = presenter.titleForHeader()
        }
    }
    
}

//MARK: - Extensions

//MARK: - WordsCountViewInput
extension WordsCountViewController: WordsCountViewInput {
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func makeNavigationButtonEnable() {
        navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
}

//MARK: - UITableViewDataSource
extension WordsCountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardConstants.CellID.wordCountCell, for: indexPath)
        let item = presenter.itemFor(indexPath: indexPath)
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.quantity
        
        return cell
    }
    
}
