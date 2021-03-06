//
//  JSONType.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

enum JSONType {
    case plain(JSON)
    case array([JSON])
    case string(String)
}
