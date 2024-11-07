//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Visarg on 25.10.2024.
//

import UIKit

class MainViewController: UITableViewController {

  
    var places = Place.getPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.lacationLabel.text = place.location
        cell.tybeLabel.text = place.type
        
        if place.image == nil {
            cell.imageOfPlase?.image = UIImage(named: place.restaurantImage!)
        } else {
            cell.imageOfPlase?.image = place.image
        }
        
        
        cell.imageOfPlase?.layer.cornerRadius = cell.imageOfPlase.frame.size.height / 2
        cell.imageOfPlase?.clipsToBounds = true
        return cell
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
            places.append(newPlaceVC.newPlace!)
            tableView.reloadData()
            
    }
}
