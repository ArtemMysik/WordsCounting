//
//  WordsCountPresenter.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

protocol WordsCountViewOutput {
    func viewIsReady()
    func itemFor(indexPath: IndexPath) -> CharacterQuantityViewModel
    func itemsCount() -> Int
    func titleForHeader() -> String
    func triggerLogoutButtonTouch()
}

class WordsCountPresenter: WordsCountViewOutput {
    
    //MARK: - Properties
    weak var view: WordsCountViewInput!
    fileprivate var dataSource = [CharacterQuantityViewModel]()
    fileprivate var dataText = String()
    
    fileprivate var wordsCountDataCreator = WordsCountDataCreationWorker()
    
    //MARK: - Life Cycle
    required init(view: WordsCountViewInput) {
        self.view = view
    }
    
    //MARK: - WordsCountViewOutput
    func viewIsReady()  {
        requestText()
    }
    
    //MARK: - Private Methods
    fileprivate func proceedText(_ string: String) {
        dataSource = wordsCountDataCreator.createDataSource(from: string)
        dataText = string
        view.makeNavigationButtonEnable()
        view.reloadTable()
    }
    
    func itemFor(indexPath: IndexPath) -> CharacterQuantityViewModel {
        return dataSource[indexPath.row]
    }
    
    func itemsCount() -> Int {
        return dataSource.count
    }
    
    func titleForHeader() -> String {
        return dataText
    }
    
    func triggerLogoutButtonTouch() {
        APIClient.shared.logout()
    }
    
}

//MARK: - Extensions

//MARK: - APIClient
extension WordsCountPresenter {
    
    func requestText() {
        view.startActivityIndicator()
        
        APIClient.shared.getText { [weak self] (result) in
            self?.view.stopActivityIndicator()
            
            switch result {
            case .stringSuccess(let string):
                self?.proceedText(string)
                
            default:
                break
            }
        }
    }
    
}
