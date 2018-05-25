//
//  DataResponseResult.swift
//  WordsCount
//
//  Created by   Artem on 22.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

struct EmptySuccess: Decodable { }

enum DataResponseRessult<T: Decodable> {
    case success(T)
    case stringSuccess(String)
    case errors([DataResponseError])
    case fail(message: String)
}
