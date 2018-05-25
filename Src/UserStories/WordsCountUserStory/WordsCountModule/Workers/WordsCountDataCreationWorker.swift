//
//  WordsCountDataCreationWorker.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

struct WordsCountDataCreationWorker {
    
    func createDataSource(from string: String) -> [CharacterQuantityViewModel] {
        var dict = [String : Int]()
        
        string.forEach { (character) in
            if let value = dict[characterTitle(character)] {
                dict[characterTitle(character)] = value + 1
            } else {
                dict[characterTitle(character)] = 1
            }
        }
        
        let dataSource = dict.sorted(by: {$0.value > $1.value}).flatMap {
            CharacterQuantityViewModel(name: $0.key, quantity: String($0.value))
        }
        
        return dataSource
    }
    
    fileprivate func characterTitle(_ character: Character) -> String {
        if character == " " {
            return "Space"
        } else {
            return String(character)
        }
    }
    
}
