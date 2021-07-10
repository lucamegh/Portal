/**
 * Portal
 * Copyright (c) Luca Meghnagi 2021
 * MIT license, see LICENSE file for details
 */

import UIKit

public class ContainerViewController: UIViewController {
    
    public override var childForStatusBarStyle: UIViewController? { viewController }
    
    public var transition: ContainerViewControllerTransition? = .default
    
    public var viewController: UIViewController? {
        get { _viewController }
        set { setViewController(newValue, animated: false) }
    }
    
    private var _viewController: UIViewController?
            
    public init(viewController: UIViewController? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.viewController = viewController
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setViewController(_ viewController: UIViewController?, animated: Bool) {
        transition(from: _viewController, to: viewController, animated: animated)
        _viewController = viewController
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func transition(
        from fromViewController: UIViewController?,
        to toViewController: UIViewController?,
        animated: Bool
    ) {
        if
            let toViewController = toViewController,
            let toView = toViewController.view
        {
            toView.frame = view.bounds
            view.addSubview(toView)
            toView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                toView.widthAnchor.constraint(equalTo: view.widthAnchor),
                toView.heightAnchor.constraint(equalTo: view.heightAnchor),
                toView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                toView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            addChild(toViewController)
        }
        
        fromViewController?.willMove(toParent: nil)
        
        func completeTransition() {
            fromViewController?.view.removeFromSuperview()
            fromViewController?.removeFromParent()
            toViewController?.didMove(toParent: self)
        }
        
        guard
            animated,
            let transition = transition,
            viewIfLoaded?.window != nil
        else {
            return completeTransition()
        }
        
        let context = ContainerViewControllerTransitionContext(
            containerView: view,
            fromViewController: fromViewController,
            toViewController: toViewController,
            completion: { [transition] didComplete in
                completeTransition()
                transition.animationEnded(didComplete)
            }
        )
        
        transition.animate(using: context)
    }
}
