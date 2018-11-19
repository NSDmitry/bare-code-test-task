//
//  ProductDetailViewController.swift
//  test-task
//
//  Created by admin on 17/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = product.name

        guard let imageUrl = product.imageUrls.first else {
            return
        }
        
        let url = "https://img.napolke.ru/image/get?uuid=\(imageUrl)"
        imageView.imageFromUrl(urlString: url)
    }
}
