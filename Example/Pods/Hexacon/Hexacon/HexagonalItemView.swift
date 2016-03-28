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
    
    public var index: Int?
    
    weak var delegate: HexagonalItemViewDelegate?
    
    // MARK: - instance methods
    
    public func addImage(image: UIImage,configure: Bool,borderColor: UIColor,borderWidth: CGFloat) {
        self.image = configure ? HexagonalItemView.roundImage(image: image,color: borderColor,borderWidth: borderWidth) : image
    }
    
    public func addView(view: UIView) {
        self.image = HexagonalItemView.roundView(view: view)
    }
    
    // MARK: - event methods
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        guard let index = index else { return }
        
        delegate?.hexagonalItemViewClikedOnButton(forIndex: index)
    }
    
    // MARK: - class methods
    
    private static func roundView(view view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        view.layer.renderInContext(context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return roundImage(image: image)
    }
    
    private static func roundImage(image image: UIImage, color: UIColor? = nil, borderWidth: CGFloat = 0) -> UIImage {
        guard image.size != .zero else { return image }
        
        let newImage = image.copy() as! UIImage
        let cornerRadius = image.size.height/2
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
        let bounds = CGRect(origin: CGPointZero, size: image.size)
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
