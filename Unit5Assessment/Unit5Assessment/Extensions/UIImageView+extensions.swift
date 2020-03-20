//
//  ImageHelper.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/19/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

extension UIImageView {
    func getImage(_ imageURL: String, completion: @escaping (Result<UIImage,NetworkError>) -> ()){
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = UIColor.gray
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        guard let url = URL(string: imageURL) else {
            completion(.failure(.badURL(imageURL)))
            return
        }
        
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(request) { result in
            switch result{
            case .failure(let netError):
                DispatchQueue.main.async{
                    activityIndicator.stopAnimating()
                }
                completion(.failure(.networkClientError(netError)))
            case .success(let data):

                if let image = UIImage(data:data) {
                    DispatchQueue.main.async{
                        activityIndicator.stopAnimating()
                        completion(.success(image))
                    }
                }
            }
        }
    }
}
