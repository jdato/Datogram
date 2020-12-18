//
//  ViewController.swift
//  Datogram
//
//  Created by Johannes Dato on 18.12.20.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let context = CIContext()
    var original: UIImage?
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func chooseFoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            navigationController?.present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func applySepia() {
        guard let original = original else {
            return
        }
        
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(0.5, forKey: kCIInputIntensityKey)
        // Use if let or guard let for image!
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter)
    }
    
    @IBAction func applyNoir() {
        display(filter: CIFilter(name: "CIPhotoEffectNoir"))
    }
    
    @IBAction func applyVintage() {
        display(filter: CIFilter(name: "CIPhotoEffectProcess"))
    }
    
    @IBAction func saveFilteredPhoto() {
        guard let image = imageView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func display(filter: CIFilter?) {
        guard let filter = filter else {
            return
        }
        
        guard let original = original else {
            return
        }
        
        filter.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        let output = filter.outputImage
        imageView.image = UIImage(cgImage: self.context.createCGImage(output!, from: output!.extent)!)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        navigationController?.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            original = image
            imageView.image = original
        }
    }
}
