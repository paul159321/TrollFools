//
//  Favorite.swift
//  TrollFools
//
//  Created by paulwu on 2024/10/25.
//

import Foundation

class FavoriteFun {
    
    private let defaults = UserDefaults.standard
    private let key = "favoriteAPP"

    private func getFavorites() -> [String] {
        return defaults.array(forKey: key) as? [String] ?? []
    }

    func updateFavorite(_ target: String) {
        var favorites = getFavorites()
        if let index = favorites.firstIndex(of: target) {
            favorites.remove(at: index)
        } else {
            favorites.append(target)
        }
        defaults.set(favorites, forKey: key)
    }

    func isBundleFavorite(_ target: String) -> Bool {
        let favorites = getFavorites()
        return favorites.contains(target)
    }
}
