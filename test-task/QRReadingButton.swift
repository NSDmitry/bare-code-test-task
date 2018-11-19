//
//  QRReadingButton.swift
//  test-task
//
//  Created by admin on 18/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import UIKit

// TODO: - remove states, add isQRReading

enum QRReadingButtonState {
    case normal
    case QRReading
}

class QRReadingButton: UIButton {
    
    var qrReadingState: QRReadingButtonState = .normal {
        didSet {
            switch qrReadingState {
            case .normal:
                self.backgroundColor = .blue
                self.setTitle("Сканировать", for: .normal)
            case .QRReading:
                self.backgroundColor = .red
                self.setTitle("Остановить", for: .normal)
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
        self.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
    }
    
    @objc func buttonDidTapped() {
        let newState: QRReadingButtonState = qrReadingState == .normal ? .QRReading : .normal
        self.qrReadingState = newState
    }
}
