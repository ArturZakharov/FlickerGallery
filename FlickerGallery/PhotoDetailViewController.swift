//
//  PhotoDetailViewController.swift
//  FlickerGallery
//
//  Created by ArturZaharov on 15.02.2022.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var mainImage: UIImageView!
    
    var photo: Photo?
    let netWorkManger = NetWorkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView(){
        if let photo = photo {
            netWorkManger.download(imageURLString: photo.urlS!) { imageData, error in
                guard let imageData = imageData else {
                    self.mainImage.image = UIImage(systemName: "picture")
                    return
                }
                
                let img = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.mainImage.image = img
                }
            }
        }
    }
}


