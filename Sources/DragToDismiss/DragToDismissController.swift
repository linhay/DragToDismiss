//
//  File.swift
//
//
//  Created by linhey on 2024/9/5.
//

import UIKit

 public final class DragToDismissController: UIViewController {
    
    public let transition = DragToDismissTransition()
    public let gesture = DragToDismissGesture()
    private var viewDidLoadTask: (() -> Void)?
    
    public var sourceView: UIView? {
        get { transition.sourceView }
        set { transition.sourceView = newValue }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .custom
        transitioningDelegate = transition
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .custom
        transitioningDelegate = transition
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        gesture.bind(dismiss: self)
        gesture.bind(containerView: view)
        viewDidLoadTask?()
        viewDidLoadTask = nil
    }
    
    public func add(content content: UIView) {
        if self.isViewLoaded {
            view.addSubview(content)
            content.frame = view.bounds
            gesture.bind(contentView: content)
            transition.targetView = content
        } else {
            viewDidLoadTask = { [weak self, weak content] in
                guard let self = self, let content = content else {
                    return
                }
                self.add(content: content)
            }
        }
    }
    
    public func add(content content: UIViewController) {
        self.addChild(content)
        if self.isViewLoaded {
            self.add(content: content.view)
        } else {
            viewDidLoadTask = { [weak self, weak content] in
                guard let self = self, let content = content else {
                    return
                }
                self.add(content: content.view)
            }
        }
    }
    
}
