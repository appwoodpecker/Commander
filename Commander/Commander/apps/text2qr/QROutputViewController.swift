//
//  QROutputViewController.swift
//  Commander
//
//  Created by zhangxiaogang on 2019/9/26.
//  Copyright © 2019 woodpecker. All rights reserved.
//

import Cocoa

class QROutputViewController: NSViewController {
    
    var text: String?

    @IBOutlet weak var imageView: NSImageView!
    
    @IBOutlet weak var textTextField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.text == nil) {
            return
        }
        textTextField.maximumNumberOfLines = 6
        genQR()
    }
    
    func genQR() {
        guard let text = text else {
            return
        }
        guard let filter = CIFilter.init(name: "CIQRCodeGenerator") else {
            textTextField.stringValue = "convert to qr failed"
            return
        }
        filter.setDefaults()
        if let data = text.data(using: String.Encoding.utf8) {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel");
        }
        if let ciImage = filter.outputImage {
            //scale qr 10x
            let scale = 10.0 as CGFloat
            let transform = CGAffineTransform.init(scaleX: scale, y: scale)
            let scaledImage = ciImage.transformed(by: transform)
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                let size = scaledImage.extent.size
                let image = NSImage.init(cgImage: cgImage, size: size)
                self.imageView.image = image
            }
        }
        textTextField.stringValue = text
        textTextField.toolTip = text
    }
    
}
