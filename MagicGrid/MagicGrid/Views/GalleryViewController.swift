//
//  GalleryViewController.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/6/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit

class GalleryViewController: UICollectionViewController {
    
    var viewModel:GalleryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.didAppear()
    }
    
    // MARK: Private Methods
    private func setupViewModel(){
        self.viewModel = GalleryViewModel.create()
        self.viewModel.reloadGallery = {[unowned self] in
            self.collectionView?.reloadData()
        }
    }
    
    private func delete(itemAt indexpath:IndexPath){
        self.collectionView?.performBatchUpdates({
            self.collectionView?.deleteItems(at: [indexpath])
            self.collectionView?.reloadData()
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.viewModel.remove(imageAt: indexpath)
        }, completion: nil)
    }
    
    private func addMore(){
        self.showInputDialog(title: "Add More Images",
                             subtitle: "Add url to add new image to the gallery",
                             actionTitle: "Add",
                             cancelTitle: "Cancel",
                             inputPlaceholder: "Enter Url here ..",
                             inputKeyboardType: UIKeyboardType.URL,
                             cancelHandler: nil)
        { [unowned self] inputString in
            if (inputString?.isStringLink())!{
                self.viewModel.add(imageWith: inputString!)
            }
            else{
                self.showDialog(title: "Error", subtitle: "Input should be non-empty valid url string")
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.viewModel.cellType(for: indexPath) {
        case .image:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.delete = {[unowned self] in
                self.delete(itemAt: indexPath)
            }
            cell.configure(cellFor: self.viewModel.image(forCellAt: indexPath))
            return cell
            
        case .addMore:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreCell", for: indexPath) as! AddMoreCell
            cell.addMore = {[unowned self] in
                self.addMore()
            }
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return self.viewModel.canMove(cellAt: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if collectionView.cellForItem(at: sourceIndexPath) is ImageCell && collectionView.cellForItem(at: destinationIndexPath) is ImageCell{
            self.viewModel.swap(cellsAt: sourceIndexPath, destinationIndexpath: destinationIndexPath)
        }
    }
}

