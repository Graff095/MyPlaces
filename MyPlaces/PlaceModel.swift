//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Visarg on 04.11.2024.
//

import UIKit
struct Place {
    
    var name: String
    var location: String?
    var type: String?
    var image: UIImage?
    var restaurantImage: String?
    
    static let restaurantNames = ["Burger Heroes","Kitchen", "Дастархан", "X.O", "Балкан Гриль", "Morris Pub","Вкусные истории", "Классик", "Love&Life","Шок","Бочка"
        ]
      
    static func getPlaces() -> [Place]{
        var places = [Place]()
        
        for place in restaurantNames {
            places.append(Place(name: place, location: "Грозный", type: "Ресторан", image: nil, restaurantImage: place))
        }
        return places
    }
}
