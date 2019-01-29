//
//  TableViewCell.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 17/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit

// MARK: TRASH

class TableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    var sourceController: UIViewController?
 
    let layout = UICollectionViewFlowLayout()
    @IBOutlet open weak var selfiesCollection: UICollectionView!
    

    
    override  func awakeFromNib() {
        super.awakeFromNib()
//     MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE
        selfiesCollection.delegate = self
        selfiesCollection.dataSource = self
        selfiesCollection.register(UINib(nibName:"voidCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "voidCollectionViewCell")
  //     MARK: - COLLECTIONVIEW LAYOUT
        let itemSize: Double = Double(UIScreen.main.bounds.width/3 - 15)
    
        layout.sectionInset = UIEdgeInsetsMake(8, 20, 7, 20)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 2.5
        layout.minimumLineSpacing = 2.5
        selfiesCollection.collectionViewLayout = layout

       
      NotificationCenter.default.addObserver(self, selector: #selector(reloadCollections(_:)), name: Notification.Name("ReloadCollectionViews"), object: nil)
    }
    
    
    @objc func reloadCollections( _ sender: Notification){
        selfiesCollection.reloadData()
    }
    

    
    //    MARK:- BOTTOM COLLECTION VIEW SETUP
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoShared.shared.favourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        cell.layer.borderWidth = 0.1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = 5
        if let cellImage = cell.viewWithTag(2) as? UIImageView {
            
            if let _ = PhotoShared.shared.setOfFavourites{
                cellImage.image = PhotoShared.shared.favourites[indexPath.item]
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = PhotoShared.shared.setOfFavourites {
            if let controller = UIStoryboard(name: "Main",bundle: Bundle.main).instantiateViewController(withIdentifier: "MySelfiesDetailsViewController") as? MySelfiesDetailsViewController {
                controller.photo = PhotoShared.shared.favourites[indexPath.item]
                controller.index = indexPath.item
                controller.photoType = .favourite
                let vc = UINavigationController(rootViewController: controller)
                if let source = sourceController{
                    source.present(_:vc,animated:true,completion:nil)
                }
            }else{
                return
            }
        }
    }
}
