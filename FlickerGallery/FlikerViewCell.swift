//
//  FlikerViewCell.swift
//  FlickerGallery
//
//  Created by ArturZaharov on 14.02.2022.
//

import UIKit

class FlikerViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static let cellId = "cell"
    var representedIdentifier: String = ""
    
    var image: UIImage? {
      didSet {
        imageView.image = image
      }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
