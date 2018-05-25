//
//  DataResponseError.swift
//  WordsCount
//
//  Created by   Artem on 22.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

struct DataResponseError: Decodable {
    var name: String
    var message: String
}
