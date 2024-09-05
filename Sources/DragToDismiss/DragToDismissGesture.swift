//
//  File.swift
//  
//
//  Created by linhey on 2024/9/5.
//

import UIKit

public class DragToDismissGesture: NSObject, UIGestureRecognizerDelegate {
    
    weak var contentView: UIView?
    weak var containerView: UIView?
    weak var viewController: UIViewController?
    
    private var initialFrame = CGRect.zero
    private var initialTouchPoint = CGPoint.zero
    private var initialBackgroundColor = UIColor.black.withAlphaComponent(0.6)

    private let minScale: CGFloat = 0.3
    private let maxScale: CGFloat = 1.0
    private let animationDuration: TimeInterval = 0.3
    
    public func bind(dismiss viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func bind(containerView: UIView) {
        self.containerView = containerView
        containerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    public func bind(contentView: UIView) {
        self.contentView = contentView
    }
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        [weak self] in
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()
    
    @objc open func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let contentView = contentView, let containerView = containerView else { return }
        
        switch gestureRecognizer.state {
        case .began:
            initialFrame = contentView.frame
            initialTouchPoint = gestureRecognizer.location(in: containerView)
        case .changed:
            let result = calculatePanResult(gestureRecognizer)
            contentView.frame = result.frame
            containerView.backgroundColor = initialBackgroundColor.withAlphaComponent(result.scale * result.scale)
        case .ended, .cancelled:
            let isDismiss = contentView.convert(contentView.bounds, to: containerView).minX > containerView.bounds.width / 2
            if isDismiss {
                viewController?.dismiss(animated: true)
            } else {
                resetContentViewPosition()
            }
        default:
            resetContentViewPosition()
        }
    }
    
    private func calculatePanResult(_ gestureRecognizer: UIPanGestureRecognizer) -> (frame: CGRect, scale: CGFloat) {
        guard let containerView = containerView else { return (.zero, 1) }
        let translation = gestureRecognizer.translation(in: containerView)
        let scale = scale(for: translation, in: containerView)
        
        let currentTouchPoint = gestureRecognizer.location(in: containerView)
        let newWidth = initialFrame.size.width * scale
        let newHeight = initialFrame.size.height * scale
        
        let xProportion = (initialTouchPoint.x - initialFrame.origin.x) / initialFrame.size.width
        let newX = currentTouchPoint.x - xProportion * newWidth
        
        let yProportion = (initialTouchPoint.y - initialFrame.origin.y) / initialFrame.size.height
        let newY = currentTouchPoint.y - yProportion * newHeight
        
        return (CGRect(x: newX.isNaN ? 0 : newX,
                       y: newY.isNaN ? 0 : newY,
                       width: newWidth, 
                       height: newHeight),
                scale)
    }
    
    private func scale(for translation: CGPoint, in view: UIView) -> CGFloat {
        return min(maxScale, max(minScale, 1 - translation.x / view.bounds.width))
    }
    
    private func resetContentViewPosition() {
        guard let contentView = contentView, let containerView = containerView else { return }
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            contentView.frame = self.initialFrame
            containerView.backgroundColor = self.initialBackgroundColor
        })
    }
}
