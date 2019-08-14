//
//  CommentCache.swift
//  Selecao4All
//
//  Created by Giovani Nícolas Bettoni on 14/08/19.
//  Copyright © 2019 Giovani Nícolas Bettoni. All rights reserved.
//

import Foundation

//set, get & remove Comments in cache
struct ListCache {
    static let key = "userListCache"
    static func save(_ value: Lista!) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
    }
    static func get() -> Lista! {
        var userData: Lista!
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            userData = try? PropertyListDecoder().decode(Lista.self, from: data)
            return userData!
        } else {
            return userData
        }
    }
    static func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
