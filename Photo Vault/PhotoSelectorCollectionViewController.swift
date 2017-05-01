//
//  PhotoSelectorCollectionViewController.swift
//  Photo Vault
//
//  Created by Zachary Whitten on 2/27/17.
//  Copyright © 2017 16^2. All rights reserved.
//

import UIKit
import Foundation
import Photos

private let reuseIdentifier = "selectorCell"

class PhotoSelectorCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImages = [Int]()
    
    /*
     This value is either passed by `PhotoSelectorTableViewController` in `prepare(for:sender:)`
     */
    var images = [UIImage]()
    var imagesAlbum = PHAssetCollection()
    var photosCollectionViewController: PhotosCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add the save bar button item to the navigation bar. Save button is initally disabled because no images are selected yet
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem?.isEnabled = false
        //Allow multiple images to be selected
        self.collectionView?.allowsMultipleSelection = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
                
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    // MARK: - Navigation
    
    func save(){
        photosCollectionViewController?.selectedImages = selectedImages
        photosCollectionViewController?.selectedImagesAlbum = imagesAlbum
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoSelectorCollectionViewCell else{
             fatalError("Unexpected cell type")
        }
        
        // Configure the cell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    let itemsPerRow: CGFloat = 4
    let sectionInsets = UIEdgeInsets(top: 1.0, left: 0, bottom: 0, right: 0)
    let pointWidth = UIScreen.main.nativeBounds.width / UIScreen.main.nativeScale
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthPerItem = floor(pointWidth / itemsPerRow)
        if widthPerItem == pointWidth / itemsPerRow {
            widthPerItem = widthPerItem - 0.5
        }
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //Calculates the minimum spacing the autolayout provides for width. This value is returned so the spacing is the same for the height as well as the width
        var widthPerItem = floor(pointWidth / itemsPerRow)
        if widthPerItem == pointWidth / itemsPerRow {
            widthPerItem = widthPerItem - 0.5
        }
        return (pointWidth - (widthPerItem * itemsPerRow)) / (itemsPerRow - 1)
    }
    
    
    // MARK: UICollectionViewDelegate
     //Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
     }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedImages.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        selectedImages.append(indexPath.row)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedImages.remove(object: indexPath.row)
        if selectedImages.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}
