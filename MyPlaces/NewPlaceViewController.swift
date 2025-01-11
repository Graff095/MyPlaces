//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Visarg on 05.11.2024.
//

import UIKit
import Cosmos

class NewPlaceViewController: UITableViewController, UINavigationControllerDelegate {
    
    var currentPlace: Place!
    var imageIsChanged = false
    var currentRating = 0.0
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeTupe: UITextField!
    @IBOutlet weak var retingControl: RatingControl!
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x:0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
//tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
        settingCosmosView ()
    }

    
 //MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Камера", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            
            let photo = UIAlertAction(title: "Фото", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            let cansel = UIAlertAction(title: "Назад", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cansel)
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    @IBAction func cancelAction(_ sender: Any) {
        
        dismiss(animated: true  )
    }
    
    //MARK: setting CosmosView
    func settingCosmosView (){
        
        cosmosView.settings.starSize = 40
        cosmosView.settings.emptyBorderWidth = 2
        cosmosView.didTouchCosmos = { rating in
            self.currentRating = rating
        }
        
    }
}

//MARK: Text field delegate

extension NewPlaceViewController:UITextFieldDelegate{
    
    // скрываем клавиатуру по нажатию  на Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged () {
        
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            let identifier = segue.identifier,
            let mapVC = segue.destination as? MapViewController
        else { return }
        mapVC.incomeSegueIdentifier = identifier
        if identifier == "showPlace" {
            mapVC.place.name = placeName.text!
            mapVC.place.location = placeLocation.text!
            mapVC.place.type = placeTupe.text!
            mapVC.place.imageData = placeImage.image?.pngData()
        }

    }
    
    
    func savePlace () {
        
        
        
        // 1 варинат
        
        let image = imageIsChanged ? placeImage.image :  UIImage(named: "imagePlaceholder")
        
        
    
        let imageData = image?.pngData()
        
        let newPlase = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeTupe.text,
                             imageData: imageData, rating: currentRating)
        
        if currentPlace != nil {
            try! realm.write{
                currentPlace?.name = newPlase.name
                currentPlace?.location = newPlase.location
                currentPlace?.type = newPlase.type
                currentPlace?.imageData = newPlase.imageData
                
                // Обновляем рейтинг только если он изменился
                if cosmosView.rating != currentPlace.rating {
                    currentPlace?.rating = newPlase.rating
                            }
                
                
            }
        }
        
        else {
            
            StorageManager.saveObject(newPlase)
        }
        
    }
    
    private func setupEditScreen() {
        
        if currentPlace != nil {
            setupNavigationBar()
            
            imageIsChanged = true
            
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else {return}
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeTupe.text = currentPlace?.type
            cosmosView.rating = currentPlace.rating
            
        }
    }
    
    private func setupNavigationBar () {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
}

//MARK: Work with image

extension NewPlaceViewController: UIImagePickerControllerDelegate {
    
    func chooseImagePicker (source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        
        imageIsChanged = true
        dismiss(animated: true)
    }
}
