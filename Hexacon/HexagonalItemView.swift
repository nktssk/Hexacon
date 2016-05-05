//
//  HexagonalItemView.swift
//  Hexacon
//
//  Created by Gautier Gdx on 13/02/16.
//  Copyright © 2016 Gautier. All rights reserved.
//

import UIKit

protocol HexagonalItemViewDelegate: class {
    func hexagonalItemViewClikedOnButton(forIndex index: Int)
}

public class HexagonalItemView: UIImageView {
    
    // MARK: - data
    
    public init(image: UIImage, appearance: HexagonalItemViewAppearance) {
        if appearance.needToConfigureItem {
            let modifiedImage = image.roundImage(appearance.itemBorderColor, borderWidth: appearance.itemBorderWidth)
            super.init(image: modifiedImage)
        } else {
            super.init(image: image)
        }
    }
    
    public init(view: UIView) {
        let image = view.roundImage()
        super.init(image: image)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var index: Int?
    
    weak var delegate: HexagonalItemViewDelegate?
    
    // MARK: - event methods
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        guard let index = index else { return }
        
        delegate?.hexagonalItemViewClikedOnButton(forIndex: index)
    }

}

internal extension UIView {
    
    func roundImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.layer.renderInContext(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image.roundImage()
    }

}

internal extension UIImage {
    
    func roundImage(color: UIColor? = nil, borderWidth: CGFloat = 0) -> UIImage {
        guard self.size != .zero else { return self }
        
        let newImage = self.copy() as! UIImage
        let cornerRadius = self.size.height/2
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
        let bounds = CGRect(origin: CGPointZero, size: self.size)
        let path = UIBezierPath(roundedRect: CGRectInset(bounds, borderWidth / 2, borderWidth / 2), cornerRadius: cornerRadius)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)
        // Clip the drawing area to the path
        path.addClip()
        
        // Draw the image into the context
        newImage.drawInRect(bounds)
        CGContextRestoreGState(context)
        
        // Configure the stroke
        color?.setStroke()
        path.lineWidth = borderWidth
        
        // Stroke the border
        path.stroke()
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage ?? UIImage()
    }

}
