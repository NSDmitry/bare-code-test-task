//
//  UIImage+Download.swift
//  test-task
//
//  Created by admin on 17/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let imageData = data {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: imageData)
                    }
                }
            }
            
            task.resume()
        }
    }
}
