//
//  CustomNaviAnimator.swift
//  CustomAnimation
//
//  Created by jasnig on 16/6/23.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

private var customDelegateKey = 0
private var panGestureKey = 1
// MARK: - extension UINavigationController 手势(gesture)
extension UINavigationController {
    // 添加的滑动手势
    private var zj_panGesture: UIPanGestureRecognizer? {
        set {
            objc_setAssociatedObject(self, &panGestureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &panGestureKey) as? UIPanGestureRecognizer
        }
    }
    // self.delegate
    private var zj_customDelegate: ZJNavigationControllerDelegate? {
        set {
            objc_setAssociatedObject(self, &customDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &customDelegateKey) as? ZJNavigationControllerDelegate
        }
    }
    /// 是否开启全屏pop手势
    func zj_enableFullScreenPop(isEnabled: Bool) {
        if isEnabled {
            if zj_customDelegate == nil {
                zj_customDelegate = ZJNavigationControllerDelegate()
                zj_panGesture = UIPanGestureRecognizer()
                zj_customDelegate?.panGesture = zj_panGesture
                delegate = zj_customDelegate
            }
        } else {
            zj_customDelegate = nil
            zj_panGesture = nil
            delegate = nil
            
        }
    }
    
}

class ZJNavigationControllerInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var panGesture: UIPanGestureRecognizer! = nil {
        didSet {
            panGesture.addTarget(self, action: #selector(self.handlePan(gesture:)))

        }
    }
    var containerView: UIView!
    var navigationController: UINavigationController! = nil {
        didSet {
            containerView = navigationController.view
            containerView.addGestureRecognizer(panGesture)
            
        }
    }
    var isInteracting = false
    
    override init() {
        super.init()
        
    }

    func handlePan(gesture: UIPanGestureRecognizer) {
        
        func finishOrCancel() {
            let translation = gesture.translation(in: containerView)
            let percent = translation.x / containerView.bounds.width
            let velocityX = gesture.velocity(in: containerView).x
            let isFinished: Bool
            
            // 修改这里可以改变手势结束时的处理
            if velocityX > 100 {
                isFinished = true
            } else if percent > 0.5 {
                isFinished = true
            } else {
                isFinished = false
            }
            
            isFinished ? finish() : cancel()
        }
        
        switch gesture.state {
            
        case .began:
            isInteracting = true
            // pop
            if navigationController.viewControllers.count > 0 {
                
                _ = navigationController.popViewController(animated: true)
            }
        case .changed:
            if isInteracting {
                let translation = gesture.translation(in: containerView)
                var percent = translation.x / containerView.bounds.width
                percent = max(percent, 0)

                update(percent)
                
            }
        case .cancelled:
            if isInteracting {
                finishOrCancel()
                isInteracting = false
                
            }
        case .ended:
            if isInteracting {
                finishOrCancel()
                isInteracting = false
                
            }
        default:
            break
            
        }
        
    }

}
class ZJNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    let animator = ZJNavigationControllerAnimator()
    let interactive = ZJNavigationControllerInteractiveTransition()
    var panGesture: UIPanGestureRecognizer! = nil {
        didSet {
            interactive.panGesture = panGesture
        }
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        interactive.navigationController = navigationController
        
        animator.operation = operation
        return animator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive.isInteracting ? interactive : nil
    }
//    deinit {
//        print("\(self.debugDescription) --- 销毁")
//    }
}

class ZJNavigationControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.35
    var operation: UINavigationControllerOperation = .none
    func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // fromVc 总是获取到正在显示在屏幕上的Controller
        let fromVc = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey)!
        // toVc 总是获取到将要显示的controller
        let toVc = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey)!
        
        let containView = transitionContext.containerView()
        
        let toView: UIView
        let fromView: UIView
        // Animators should not directly manipulate a view controller's views and should
        // use viewForKey: to get views instead.
        if transitionContext.responds(to:NSSelectorFromString("viewForKey:")) {
            // 通过这种方法获取到view不一定是对应controller.view
            toView = transitionContext.view(forKey: UITransitionContextToViewKey)!
            fromView = transitionContext.view(forKey: UITransitionContextFromViewKey)!
        } else {
            toView = toVc.view
            fromView = fromVc.view
        }
        
        
        // 最终显示在屏幕上的controller的frame
        let visibleFrame = transitionContext.initialFrame(for: fromVc)
        // 隐藏在右边的controller的frame
        let rightHiddenFrame = CGRect(origin: CGPoint(x: visibleFrame.width, y: visibleFrame.origin.y) , size: visibleFrame.size)
        // 隐藏在左边的controller的frame
        let leftHiddenFrame = CGRect(origin: CGPoint(x: -visibleFrame.width/2, y: visibleFrame.origin.y) , size: visibleFrame.size)
        
        if operation == .push {// push
            toView.frame = rightHiddenFrame
            fromView.frame = visibleFrame
            //  添加toview到最上面(fromView是当前显示在屏幕上的view不用添加)
            containView.addSubview(toView)
            
        } else {// pop
            fromView.frame = visibleFrame
            toView.frame = leftHiddenFrame
            // 有时需要将toView添加到fromView的下面便于执行动画
            containView.insertSubview(toView, belowSubview: fromView)
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: {
            if self.operation == .push {
                toView.frame = visibleFrame
                fromView.frame = leftHiddenFrame
            } else {
                fromView.frame = rightHiddenFrame
                toView.frame = visibleFrame
            }
            
        }) { (_) in
            let cancelled = transitionContext.transitionWasCancelled()
            if cancelled {
                // 如果中途取消了就移除toView(可交互的时候会发生)
                toView.removeFromSuperview()
            }
            // 通知系统动画是否完成或者取消了(必须)
            transitionContext.completeTransition(!cancelled)
        }
    }
//    deinit {
//        print("\(self.debugDescription) --- 销毁")
//    }

}



