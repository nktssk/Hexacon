//
//  ZenlyHexaView.swift
//  Hexacon
//
//  Created by Gautier Gdx on 05/02/16.
//  Copyright © 2016 Gautier. All rights reserved.
//

import UIKit

public protocol HexagonalViewDelegate: class {
    func hexagonalView(hexagonalView: HexagonalView, didSelectItemAtIndex index: Int)
}

public protocol HexagonalViewDataSource: class {
    func numberOfItemInHexagonalView(hexagonalView: HexagonalView) -> Int
    func hexagonalView(hexagonalView: HexagonalView,imageForIndex index: Int) -> UIImage
}

public final class HexagonalView: UIScrollView {
    
    // MARK: - subviews
    
    private lazy var contentView = UIView()
    
    // MARK: - data
    
    //apperance of the itm in the hexagonal grid
    public var itemAppearance: HexagonalItemViewAppearance
    
    //used to snap the view after scroll
    private var centerOnEndScroll = false
    
    //delegate
    public weak var hexagonalDelegate: HexagonalViewDelegate?
    
    //datasource
    public weak var hexagonalDataSource: HexagonalViewDataSource?
    
    //we are using a zoom cache setted to 1 to make the snap work even if the user haven't zoomed yet
    private var zoomScaleCache: CGFloat = 1
    
    private var lastFocusedViewIndex: Int = 0
    
    //ArrayUsed to contain all the view in the Hexagonal grid
    private var viewsArray = [HexagonalItemView]()
    
    //manager to create the hexagonal grid
    private var hexagonalPattern: HexagonalPattern!
    
    // MARK: - init
    
    
    
    public init(frame: CGRect, itemAppearance: HexagonalItemViewAppearance) {
        self.itemAppearance = itemAppearance
        super.init(frame: frame)
        
        //configure scrollView
        delaysContentTouches = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
        bouncesZoom = false
        decelerationRate = UIScrollViewDecelerationRateFast
        delegate = self
        minimumZoomScale = 0.2
        maximumZoomScale = 2

        //add contentView
        addSubview(contentView)
    }
    
    convenience public override init(frame: CGRect) {
        self.init(frame: frame, itemAppearance: HexagonalItemViewAppearance.defaultAppearance())
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - configuration methods
    
    public func reloadData() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        viewsArray = [HexagonalItemView]()
        
        guard let datasource = hexagonalDataSource else { return }
        
        let numberOfItems = datasource.numberOfItemInHexagonalView(self)
        
        guard numberOfItems > 0 else { return }
        
        for index in 0...numberOfItems {
            viewsArray.append(createHexagonalViewItem(index))
        }
        
        self.createHexagonalGrid()
    }
    
    private func createHexagonalGrid() {
        //instantiate the hexagonal pattern with the number of views
        hexagonalPattern = HexagonalPattern(size: viewsArray.count, itemSpacing: itemAppearance.itemSpacing, itemSize: itemAppearance.itemSize)
        hexagonalPattern.delegate = self
        
        //set the contentView frame with the theorical size of th hexagonal grid
        let contentViewSize = hexagonalPattern.sizeForGridSize()
        contentView.bounds = CGRectMake(0, 0, contentViewSize, 1.5*contentViewSize)
        contentView.center = center
        
        //start creating hte grid
        hexagonalPattern.createGrid(FromCenter: CGPoint(x: contentView.frame.width/2, y: contentView.frame.height/2))
    }

    private func createHexagonalViewItem(index: Int) -> HexagonalItemView {
        //instantiate the userView with the user
        let itemView = HexagonalItemView(frame: CGRect(x: 0, y: 0, width: itemAppearance.itemSize, height: itemAppearance.itemSize))
        itemView.userInteractionEnabled = true
        //setting the delegate
        itemView.delegate = self
        
        //adding index in order to retrive the view later
        itemView.index = index
        
        //adding image with the proper configuration
        itemView.addImage(hexagonalDataSource!.hexagonalView(self, imageForIndex: index),
                            configure: itemAppearance.needToConfigureItem,
                            borderColor: itemAppearance.itemBorderColor,
                            borderWidth: itemAppearance.itemBorderWidth)
        
        if itemAppearance.animationType != .None {
            //setting the scale to 0 to perform lauching animation
            itemView.transform = CGAffineTransformMakeScale(0, 0)
        }
        
        //add to content view
        self.contentView.addSubview(itemView)
        return itemView
    }
    
    private func positionAndAnimateItemView(forCenter center: CGPoint, ring: Int, index: Int) {
        guard itemAppearance.animationType != .None else { return }
        
        //set the new view's center
        let view = viewsArray[index]
        view.center = CGPoint(x: center.x,y: center.y)
        
        let animationIndex = Double(itemAppearance.animationType == .Spiral ? index : ring)
        
        //make a pop animation
        UIView.animateWithDuration(0.3, delay: NSTimeInterval(animationIndex*itemAppearance.animationDuration), usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            view.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    private func transformView(view: HexagonalItemView) {
        let size = bounds.size
        let zoomScale = zoomScaleCache
        let insets = contentInset
        let spacing = itemAppearance.itemSize + itemAppearance.itemSpacing/2
        
        //convert the ivew rect in the contentView coordinate
        var frame = convertRect(view.frame, fromView: view.superview)
        //substract content offset to it
        frame.origin.x -= contentOffset.x
        frame.origin.y -= contentOffset.y
        
        //retrieve the center
        let center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        var	distanceToBorder: CGFloat = size.width
        let distanceToBeOffset = spacing * zoomScale
        
        
        //check if the view is close to the left
        //changing the distance to border and the offset accordingly
        let leftDistance = center.x - insets.left
        if leftDistance < distanceToBeOffset && leftDistance < distanceToBorder {
            distanceToBorder = leftDistance
        }
        
        //same for top
        let topDistance = center.y - insets.top
        if topDistance < distanceToBeOffset && topDistance < distanceToBorder {
            distanceToBorder = topDistance
        }
        
        //same for right
        let rightDistance = size.width - center.x - insets.right
        if rightDistance < distanceToBeOffset && rightDistance < distanceToBorder {
            distanceToBorder = rightDistance
        }
        
        //same for bottom
        let bottomDistance = size.height - center.y - insets.bottom
        if bottomDistance < distanceToBeOffset && bottomDistance < distanceToBorder {
            distanceToBorder = bottomDistance
            
        }
        
        //if we are close to a border
        distanceToBorder *= 2
        if distanceToBorder < distanceToBeOffset * 2 {
        //if ere are out of bound
            if distanceToBorder < CGFloat(-(Int(spacing*2.5))) {
                //hide the view
                view.transform = CGAffineTransformMakeScale(0, 0)
            } else {
                //find the new scale
                var scale = max(distanceToBorder / (distanceToBeOffset * 2), 0)
                scale = 1-pow(1-scale, 2)
                
                //transform the view
                view.transform = CGAffineTransformMakeScale(scale, scale)
            }
        } else {
            view.transform = CGAffineTransformIdentity
        }
        view.setNeedsLayout()
    }
    
    private func centerScrollViewContents() {
        let boundsSize = bounds.size
        var contentsFrame = contentView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        contentView.frame = contentsFrame
    }
    
    private func centerOnIndex(index: Int, zoomScale: CGFloat) {
        guard centerOnEndScroll else { return }
        centerOnEndScroll = false

        //the view to center
        let view = viewsArray[Int(index)]

        //find the rect of the view in the contentView scale
        let rectInSelfSpace = HexagonalView.rectInContentView(point: view.center, zoomScale: zoomScale, size: bounds.size)
        scrollRectToVisible(rectInSelfSpace, animated: true)
    }
    
    
    // MARK: - public methods
    
    /**
    retrive the HexagonalItemView from the HexagonalView if it's exist
    
    - parameter index: the current index of the HexagonalItemView
    
    - returns: an optionnal HexagonalItemView
    */
    func viewForIndex(index: Int) -> HexagonalItemView? {
        guard index < viewsArray.count else { return nil }
        
        return viewsArray[index]
    }
    
    
    // MARK: - class methods
    
    private static func rectInContentView(point point: CGPoint,zoomScale: CGFloat, size: CGSize) -> CGRect {
        let center = CGPointMake(point.x * zoomScale, point.y * zoomScale)
        
        return CGRectMake(center.x-size.width*0.5, center.y-size.height*0.5, size.width, size.height)
    }

    private static func closestIndexToContentViewCenter(contentViewCenter: CGPoint,currentIndex: Int,views: [UIView]) -> Int {
        var hasItem = false
        var distance: CGFloat = 0
        var index = currentIndex
        
        views.enumerate().forEach { (viewIndex: Int, view: UIView) -> () in
            let center = view.center
            let potentialDistance = distanceBetweenPoint(x1: center.x, y1: center.y, x2: contentViewCenter.x, y2: contentViewCenter.y)
            
            if potentialDistance < distance || !hasItem {
                hasItem = true
                distance = potentialDistance
                index = viewIndex
            }
        }
        return index
    }
    
    private static func distanceBetweenPoint(x1 x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) ->  CGFloat {
        let distance = Double((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
        let squaredDistance = sqrt(distance)
        return CGFloat(squaredDistance)
    }
}

// MARK: - UIScrollViewDelegate

extension HexagonalView: UIScrollViewDelegate {
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        zoomScaleCache = zoomScale
        
        //center the contentView each time we zoom
        centerScrollViewContents()
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        //for each view snap if close to border
        for view in viewsArray {
            transformView(view)
        }
    }

    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let size = self.bounds.size
        
        //the new contentView offset
        let newOffset: CGPoint = targetContentOffset.memory
        
        //put proposedTargetCenter in coordinates relative to contentView
        var proposedTargetCenter = CGPointMake(newOffset.x+size.width/2, newOffset.y+size.height/2)
        proposedTargetCenter.x /= zoomScale
        proposedTargetCenter.y /= zoomScale
        
        //find the closest userView relative to contentView center
        lastFocusedViewIndex = HexagonalView.closestIndexToContentViewCenter(proposedTargetCenter, currentIndex: lastFocusedViewIndex, views: viewsArray)
        
        //tell that we need to center on new index
        centerOnEndScroll = true
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //if we don't need do decelerate
        guard  !decelerate else { return }
        
        //center the userView
        centerOnIndex(lastFocusedViewIndex, zoomScale: zoomScale)
    }
        
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //center the userView
        centerOnIndex(lastFocusedViewIndex, zoomScale: zoomScale)
    }
}


// MARK: - HexagonalPatternDelegate

extension HexagonalView: HexagonalPatternDelegate {
    
    func hexagonalPattern(DidCreatePosition center: CGPoint, forRing ring: Int, andIndex index: Int) {
        positionAndAnimateItemView(forCenter: center, ring: ring, index: index)
    }
}

extension HexagonalView: HexagonalItemViewDelegate {
    
    func hexagonalItemViewClikedOnButton(forIndex index: Int) {
        hexagonalDelegate?.hexagonalView(self, didSelectItemAtIndex: index)
    }
}
