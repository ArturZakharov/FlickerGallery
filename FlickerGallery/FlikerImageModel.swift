//
//  PhotosModel.swift
//  FlickerGallery
//
//  Created by ArturZaharov on 14.02.2022.
//


import Foundation

// MARK: - FlikerImageModel
struct FlikerImageModel: Codable {
    let photos: Photos
}

// MARK: - Photos
struct Photos: Codable {
    let photo: [Photo]
    let page: Int
    let pages: Int
}

// MARK: - Photo
struct Photo: Codable {
    let id: String
    let urlS: String?
    let title: String?
    

    enum CodingKeys: String, CodingKey {
        case id
        case urlS = "url_s"
        case title
    }
}
