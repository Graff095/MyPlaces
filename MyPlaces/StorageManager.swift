//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Visarg on 07.11.2024.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject( _ place: Place) {
        
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deleteObject(_ place: Place) {
        
        try! realm.write {
            realm.delete(place)
        }
    }
    
    
}
