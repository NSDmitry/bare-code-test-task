//
//  ProductService.swift
//  test-task
//
//  Created by admin on 17/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import Foundation

protocol ProductManagerProtocol {
    func getProduct(at QRCode: String, success: ((ProductListResponse) -> Void)?, failure: ((Error?) -> Void)?)
    func productImage(at product: Product, success: ((Data?) -> Void)?, failure: ((Error?) -> Void)?)
}

class ProductManager: ProductManagerProtocol {
    
    private enum HTTPMethod: String {
        case post = "POST"
    }
    
    private let baseURLString = "https://catalog.napolke.ru/search/catalog"
    private var task: URLSessionTask?
    
    func getProduct(at QRCode: String, success: ((ProductListResponse) -> Void)?, failure: ((Error?) -> Void)?) {
        let url = URL(string: baseURLString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.httpBody = self.httpBody(at: QRCode)
        
        self.task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                failure?(error)
                return
            }
            
            do {
                let productList: ProductListResponse = try JSONDecoder().decode(ProductListResponse.self, from: data)
                success?(productList)
            } catch {
                failure?(nil)
            }
        }
        
        task?.resume()
    }
    
    func productImage(at product: Product, success: ((Data?) -> Void)?, failure: ((Error?) -> Void)?) {
        guard let imageURL = product.imageUrls.first, let url = URL(string: "https://img.napolke.ru/image/get?uuid=\(imageURL)") else {
                failure?(nil)
                return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                failure?(error)
                return
            }
            
            success?(data)
        }
        
        task.resume()
    }
    
    private func httpBody(at QRCode: String) -> Data? {
        let baseRegion = ["0c5b2444-70a0-4932-980c-b4dc0d3f02b5", nil, nil]
        let parameters = ["text": QRCode, "region": baseRegion] as [String : Any]
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        return httpBody
    }
}


