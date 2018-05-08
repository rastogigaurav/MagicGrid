//
//  GalleryViewController.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/6/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var viewModel:GalleryViewModel!
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.didAppear()
    }
    
    // MARK: IBActions
    @IBAction func handleGesture(_ gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.galleryCollectionView.indexPathForItem(at: gesture.location(in: self.galleryCollectionView)) else {
                break
            }
            self.galleryCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            self.galleryCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            self.galleryCollectionView.endInteractiveMovement()
        default:
            self.galleryCollectionView.cancelInteractiveMovement()
        }
    }
    
    // MARK: Private Methods
    private func setupViewModel(){
        self.viewModel = GalleryViewModel.create()
        self.viewModel.reloadGallery = {[unowned self] in
            self.galleryCollectionView.reloadData()
        }
    }
    
    @objc private func delete(cellIn collectionView:UICollectionView, sender:UIButton){
        let point = collectionView.convert(sender.center, from: sender.superview!)
        if let indexPath = collectionView.indexPathForItem(at: point) {
            self.delete(itemAt: indexPath)
        }
    }
    
    private func delete(itemAt indexpath:IndexPath){
        self.galleryCollectionView.performBatchUpdates({
            self.galleryCollectionView.deleteItems(at: [indexpath])
            self.galleryCollectionView.collectionViewLayout.invalidateLayout()
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.viewModel.cellType(for: indexPath) {
        case .image:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.delete = { [unowned self] sender in
                self.delete(cellIn: collectionView, sender: sender)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.viewModel.size(forCellAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return self.viewModel.canMove(itemFrom: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if viewModel.canDrop(itemAt: proposedIndexPath){
            return originalIndexPath
        }
        return proposedIndexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.galleryCollectionView.performBatchUpdates({
            self.galleryCollectionView.collectionViewLayout.invalidateLayout()
            self.viewModel.move(itemFrom: sourceIndexPath, to: destinationIndexPath)
        }, completion: nil)
    }
}

