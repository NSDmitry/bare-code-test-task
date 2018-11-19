//
//  ProductDetailViewController.swift
//  test-task
//
//  Created by admin on 17/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    private let productManager: ProductManagerProtocol = ProductManager()
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = product.name
//        imageView.imageFromUrl(urlString: url)
        
        productManager.productImage(at: product, success: { [weak self] (data) in
            guard let imageData = data else {
                self?.imageView.image = UIImage(named: "emptyImage")
                return
            }
            
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: imageData)
            }
            
            }, failure: { (error) in
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = UIImage(named: "emptyImage")
                }
        })
    }
}
