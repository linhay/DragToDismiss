//
//  Transition.swift
//  DragToDissmiss
//
//  Created by linhey on 2024/9/5.
//

import UIKit

public class DragToDismissTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    public weak var sourceView: UIView?
    public weak var targetView: UIView?
    
    var isDisplayed: Bool = false
    
    func dismiss(using transitionContext: any UIViewControllerContextTransitioning) {
        let context = transitionContext
        guard let sourceView = sourceView,
              let targetView = targetView,
              let targetSnapshot = targetView.snapshotView(afterScreenUpdates: true) else {
            context.completeTransition(!context.transitionWasCancelled)
            return
        }
        
        let containerView = context.containerView
        let source_frame = sourceView.convert(sourceView.bounds, to: containerView)
        let target_frame = targetView.convert(targetView.bounds, to: containerView)
        
        containerView.addSubview(targetSnapshot)
        targetSnapshot.frame = target_frame
        context.viewController(forKey: .from)?.view.isHidden = true
        
        UIView.animate(withDuration: 0.25, animations: {
            targetSnapshot.frame = source_frame
            targetSnapshot.alpha = 0.0
        }) { _ in
            targetSnapshot.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
    func present(using transitionContext: any UIViewControllerContextTransitioning) {
        let context = transitionContext
        
        guard let target = context.viewController(forKey: .to),
              let source = context.viewController(forKey: .from),
              let sourceView = sourceView ?? source.view,
              let targetSnapshot = target.view.snapshotView(afterScreenUpdates: true) else {
            context.completeTransition(!context.transitionWasCancelled)
            return
        }
        
        let containerView = context.containerView
        let sourceFrame = sourceView.convert(sourceView.bounds, to: containerView)
        containerView.addSubview(targetSnapshot)
        targetSnapshot.frame = sourceFrame
        targetSnapshot.alpha = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            targetSnapshot.frame = context.finalFrame(for: target)
            targetSnapshot.alpha = 1.0
        }) { _ in
            targetSnapshot.removeFromSuperview()
            containerView.addSubview(target.view)
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
    
}

public extension DragToDismissTransition {
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.25
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        if isDisplayed {
            dismiss(using: transitionContext)
        } else {
            present(using: transitionContext)
        }
    }
    
}

public extension DragToDismissTransition {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        isDisplayed = false
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        isDisplayed = true
        return self
    }
}
