//
//  ProductService.swift
//  test-task
//
//  Created by admin on 17/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import Foundation

protocol ProductManagerProtocol {
    func getProduct(at QRCode: String, success: ((ProductListResponse?) -> Void)?, failure: ((Error?) -> Void)?)
}

class ProductManager: ProductManagerProtocol {
    
    private enum HTTPMethod: String {
        case post = "POST"
    }
    
    private let baseURLString = "https://catalog.napolke.ru/search/catalog"
    private var task: URLSessionTask?
    
    func getProduct(at QRCode: String, success: ((ProductListResponse?) -> Void)?, failure: ((Error?) -> Void)?) {
        let url = URL(string: baseURLString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.httpBody = self.httpBody(at: QRCode)
        
        self.task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                failure?(error)
                return
            }
            
            let productList: ProductListResponse = try! JSONDecoder().decode(ProductListResponse.self, from: data)
            success?(productList)
        }
        
        task?.resume()
    }
    
    private func httpBody(at QRCode: String) -> Data? {
        let baseRegion = ["0c5b2444-70a0-4932-980c-b4dc0d3f02b5", nil, nil]
        let parameters = ["text": QRCode, "region": baseRegion] as [String : Any]
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        return httpBody
    }
}

struct ProductListResponse: Decodable {
    let products: [Product]
    
    enum CodingKeys: String, CodingKey {
        case products = "data"
    }
}

struct Product: Decodable {
    var imageUrls: [String]
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrls = "images"
        case name
    }
}
