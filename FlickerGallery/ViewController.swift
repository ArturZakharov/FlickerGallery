//
//  ViewController.swift
//  FlickerGallery
//
//  Created by ArturZaharov on 14.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var flickerCollectionView: UICollectionView!
    let netWorkManager = NetWorkManager.shared
    var photoArray: [Photo] = []
    var allPagesCount: Int?
    var courentPage:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        netWorkManager.getAllPhotos(page: 1) { [weak self] flikerImageModel, error in
            if let error = error {
                print("error", error)
                return
            }
            
            self?.photoArray = flikerImageModel!.photos.photo
            self?.allPagesCount = flikerImageModel?.photos.pages
            DispatchQueue.main.async {
                self?.flickerCollectionView.reloadData()
            }
        }
    }
    
    func getMorePhotos(page: Int){
        netWorkManager.getAllPhotos(page: page) { [weak self] flikerImageModel, error in
            if let error = error {
                print("error", error)
                return
            }
            
            self?.photoArray.append(contentsOf: flikerImageModel!.photos.photo)
            DispatchQueue.main.async {
                self?.flickerCollectionView.reloadData()
            }
        }
    }
}


extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PhotoDetailViewController") as? PhotoDetailViewController
        vc?.photo = photoArray[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = photoArray[indexPath.row]
        guard let allPagesCount = allPagesCount else { return UICollectionViewCell() }
        if indexPath.row - 15 == photoArray.count - 16 && courentPage < allPagesCount{
            courentPage += 1
            getMorePhotos(page: courentPage)
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlikerViewCell.cellId, for: indexPath) as? FlikerViewCell else { return UICollectionViewCell() }
        
        
        
        let representedIdentifier = photo.id
        cell.representedIdentifier = representedIdentifier
        
        func image(data: Data?) -> UIImage? {
          if let data = data {
            return UIImage(data: data)
          }
          return UIImage(systemName: "picture")
        }
        if let urlString = photo.urlS {
            netWorkManager.download(imageURLString: urlString) { data, error in
                let img = image(data: data)
                DispatchQueue.main.async {
                  if (cell.representedIdentifier == representedIdentifier) {
                    cell.image = img
                  }
                }
            }
        }
        return cell
    }
}
    
