//
//  ImageViewerTransitionPresentationManager.swift
//  ImageViewer.swift
//
//  Created by Michael Henry Pantaleon on 2020/08/19.
//

import Foundation
import UIKit

protocol ImageViewerTransitionViewControllerConvertible {
    
    // The source view
    var sourceView: UIImageView? { get }
    
    // The final view
    var targetView: UIImageView? { get }
}

final class ImageViewerTransitionPresentationAnimator:NSObject {
    
    let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension ImageViewerTransitionPresentationAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
        -> TimeInterval {
            return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = isPresenting ? .to : .from
        guard let controller = transitionContext.viewController(forKey: key)
            else { return }
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        if isPresenting {
            presentAnimation(
                transitionView: transitionContext.containerView,
                controller: controller,
                duration: animationDuration) { finished in
                    transitionContext.completeTransition(finished)
            }
             
        } else {
            dismissAnimation(
                transitionView: transitionContext.containerView,
                controller: controller,
                duration: animationDuration) { finished in
                    transitionContext.completeTransition(finished)
            }
        }
    }
    
    private func createDummyImageView(frame: CGRect, image:UIImage? = nil)
        -> UIImageView {
            let dummyImageView:UIImageView = UIImageView(frame: frame)
            dummyImageView.clipsToBounds = true
            dummyImageView.contentMode = .scaleAspectFill
            dummyImageView.alpha = 1.0
            dummyImageView.image = image
            return dummyImageView
    }
    
    private func presentAnimation(
        transitionView:UIView,
        controller: UIViewController,
        duration: TimeInterval,
        completed: @escaping((Bool) -> Void)) {

        guard
            let transitionVC = controller as? ImageViewerTransitionViewControllerConvertible
        else { return }
        
        let sourceView = transitionVC.sourceView
        
        let dummyImageView = createDummyImageView(
            frame: sourceView?.frameRelativeToWindow() ?? .zero,
            image: sourceView?.image)
        transitionView.addSubview(dummyImageView)
        
        sourceView?.alpha = 0.0
        
        transitionView.addSubview(controller.view)
        controller.view.alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            dummyImageView.contentMode = .scaleAspectFit
            dummyImageView.frame = UIScreen.main.bounds
            controller.view.alpha = 1.0
        }) { finished in
            dummyImageView.removeFromSuperview()
            completed(finished)
        }
    }
    
    private func dismissAnimation(
        transitionView:UIView,
        controller: UIViewController,
        duration:TimeInterval,
        completed: @escaping((Bool) -> Void)) {
        
        guard
            let transitionVC = controller as? ImageViewerTransitionViewControllerConvertible
        else { return }
  
        let sourceView = transitionVC.sourceView
        let targetView = transitionVC.targetView
        
        let dummyImageView = createDummyImageView(
            frame: targetView?.frameRelativeToWindow() ?? UIScreen.main.bounds,
            image: targetView?.image)
        transitionView.addSubview(dummyImageView)
        targetView?.isHidden = true
      
        controller.view.alpha = 1.0
        UIView.animate(withDuration: duration, animations: {
            if let sourceView = sourceView {
                // return to original position
                dummyImageView.frame = sourceView.frameRelativeToWindow()
            } else {
                // just disappear
                dummyImageView.alpha = 0.0
            }
            controller.view.alpha = 0.0
        }) { finished in
            sourceView?.alpha = 1.0
            controller.view.removeFromSuperview()
            completed(finished)
        }
    }
}

final class ImageViewerTransitionPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}

final class ImageViewerTransitionPresentationManager: NSObject {
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension ImageViewerTransitionPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = ImageViewerTransitionPresentationController(
            presentedViewController: presented,
            presenting: presenting)
        return presentationController
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
 
        return ImageViewerTransitionPresentationAnimator(isPresenting: true)
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return ImageViewerTransitionPresentationAnimator(isPresenting: false)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension ImageViewerTransitionPresentationManager: UIAdaptivePresentationControllerDelegate {
    
    func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        return .none
    }
    
    func presentationController(
        _ controller: UIPresentationController,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle
    ) -> UIViewController? {
        return nil
    }
}
