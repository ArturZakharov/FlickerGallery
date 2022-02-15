//
//  NetWorkManager.swift
//  FlickerGallery
//
//  Created by ArturZaharov on 14.02.2022.
//

import Foundation

enum NetworkManagerError: Error {
    case badResponse(URLResponse?)
    case badData
    case badLocalUrl
}

class NetWorkManager{
    
    static var shared = NetWorkManager()
    private var images = NSCache<NSString, NSData>()
    let session = URLSession.shared
    private init() {}
    
    func getAllPhotos(page: Int, completion: @escaping (FlikerImageModel?, Error?) -> Void){
        
        guard let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&extras=url_s&api_key=aabca25d8cd75f676d3a74a72dcebf21&page=\(page)&format=json&nojsoncallback=1") else {
                    print("Error creating url object")
                    return
                }
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkManagerError.badResponse(response))
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkManagerError.badData)
                return
            }
            
            do {
                let flickerImageData = try JSONDecoder().decode(FlikerImageModel.self, from: data)
                print(flickerImageData)
                completion(flickerImageData, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        dataTask.resume()
    }
    
    func download(imageURLString: String, completion: @escaping (Data?, Error?) -> (Void)) {
        let imageURL = URL(string: imageURLString)!
      if let imageData = images.object(forKey: imageURL.absoluteString as NSString) {
        print("using cached images")
        completion(imageData as Data, nil)
        return
      }
      
      let task = session.downloadTask(with: imageURL) { localUrl, response, error in
        if let error = error {
          completion(nil, error)
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
          completion(nil, NetworkManagerError.badResponse(response))
          return
        }
        
        guard let localUrl = localUrl else {
          completion(nil, NetworkManagerError.badLocalUrl)
          return
        }
        
        do {
          let data = try Data(contentsOf: localUrl)
          self.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
          completion(data, nil)
        } catch let error {
          completion(nil, error)
        }
      }
      
      task.resume()
    }
}
