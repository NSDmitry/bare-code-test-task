//
//  QRReadingButton.swift
//  test-task
//
//  Created by admin on 18/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import UIKit

class QRReadingButton: UIButton {
    
    var isReading: Bool = false {
        willSet {
            if newValue {
                self.backgroundColor = .red
                self.setTitle("Остановить", for: .normal)
            } else {
                self.backgroundColor = .blue
                self.setTitle("Сканировать", for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.layer.cornerRadius = 10
        isReading = false
    }
}
