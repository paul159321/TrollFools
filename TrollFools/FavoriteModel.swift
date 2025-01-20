import Foundation

final class FavoriteModel {

    private static let markerName = ".troll-fools"

    static func isBundleFavorite(_ target: URL) -> Bool {
        let appName = target.lastPathComponent
        let favoriteList = loadFavorites()
        return favoriteList.contains(appName)
    }

    static func addFavorite(_ target: URL) {
        let appName = target.lastPathComponent
        var favoriteList = loadFavorites()
        if !favoriteList.contains(appName) {
            favoriteList.append(appName)
            saveFavorites(favoriteList)
        }
    }

    static func loadFavorites() -> [String] {
        let plistURL = getPlistURL()
        guard FileManager.default.fileExists(atPath: plistURL.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: plistURL)
            let favorites = try PropertyListDecoder().decode([String].self, from: data)
            return favorites
        } catch {
            print("Failed to load favorites: \(error)")
            return []
        }
    }

    static func saveFavorites(_ favorites: [String]) {
        let plistURL = getPlistURL()
        do {
            let data = try PropertyListEncoder().encode(favorites)
            try data.write(to: plistURL)
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }

    static func getPlistURL() -> URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not find the document directory.")
        }
        return documentDirectory.appendingPathComponent("favorite.plist")
    }
}
