//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Visarg on 25.10.2024.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {

  
    var places: Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        places = realm.objects(Place.self)
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.lacationLabel.text = place.location
        cell.tybeLabel.text = place.type
        cell.imageOfPlase.image = UIImage(data: place.imageData!)
        
        
        cell.imageOfPlase?.layer.cornerRadius = cell.imageOfPlase.frame.size.height / 2
        cell.imageOfPlase?.clipsToBounds = true
        return cell
    }
    
    // MARK: - Table view delegete
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let place = places[indexPath.row]
        let deletAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deletAction]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return}
            
            newPlaceVC.saveNewPlacee()
            tableView.reloadData()
            
    }
}
