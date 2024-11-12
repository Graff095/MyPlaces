//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Visarg on 05.11.2024.
//

import UIKit

class NewPlaceViewController: UITableViewController, UINavigationControllerDelegate {
    
    var imageIsChanged = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    

    
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeTupe: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
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
    
    func saveNewPlacee () {
        
        var image: UIImage?
        
        
        if imageIsChanged{
            image = placeImage.image
        } else {
            image = UIImage(named: "imagePlaceholder")
        }
    
        let imageData = image?.pngData()
        
        let newPlase = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeTupe.text,
                             imageData: imageData)
        StorageManager.saveObject(newPlase)
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
