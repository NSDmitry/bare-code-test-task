//
//  ProductService.swift
//  test-task
//
//  Created by admin on 17/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import Foundation

protocol ProductManagerProtocol {
    func getProduct(at QRCode: String)
}

class ProductManager: ProductManagerProtocol {
    func getProduct(at QRCode: String) {
        let parameters: [String: Any] = [
            "text": QRCode,
            "region": ["0c5b2444-70a0-4932-980c-b4dc0d3f02b5", nil, nil]
        ]
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        let urlString = "https://catalog.napolke.ru/search/catalog"
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Неизвестная ошибка")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let json = responseJSON as? [String: Any] {
                print(json)
            }
        }
        
        task.resume()
    }
}
