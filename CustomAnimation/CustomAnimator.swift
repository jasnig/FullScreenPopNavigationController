//
//  CustomAnimator.swift
//  CustomAnimation
//
//  Created by jasnig on 16/6/22.
//  Copyright © 2016年 ZeroJ. All rights reserved.
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit

class Interactive: UIPercentDrivenInteractiveTransition {
    lazy var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action:  #selector(self.handlePan(gesture:)))
    var containerView: UIView!
    var dismissedVc: UIViewController! = nil {
        didSet {
            dismissedVc.view.addGestureRecognizer(panGesture)
            containerView = dismissedVc.view
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
            if velocityX <= 0 {
                isFinished = false
            } else if velocityX > 100 {
                isFinished = true
            } else if percent > 0.3 {
                isFinished = true
            } else {
                isFinished = false
            }
            
            isFinished ? finish() : cancel()
        }
        
        switch gesture.state {

            case .began:
                isInteracting = true
                // dimiss
                dismissedVc.dismiss(animated: true, completion: nil)
            case .changed:
                if isInteracting {// 开始执行交互动画的时候才设置为非nil
                    let translation = gesture.translation(in: containerView)
                    var percent = translation.x / containerView.bounds.width
                    if percent < 0 {
                        percent = 0
                    }
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

class CustomDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private lazy var customAnimator = CustomAnimator()
    private lazy var interactive = Interactive()
    // 提供present的时候使用到的动画执行对象
    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // present 的时候设置presentedVc 便于添加手势
        interactive.dismissedVc = presented
        return customAnimator
    }
    // 提供dismiss的时候使用到的动画执行对象
    func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customAnimator
    }
    // 提供dismiss的时候使用到的可交互动画执行对象
    func interactionController(forDismissal animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // 因为执行自定义动画会先调用这个方法, 如果返回不为nil, 那么将不会执行非交互的动画!!
        // 所以isInteracting只有在手势开始的时候才被设置为true
        // 返回nil便于不是可交互的时候就直接执行不可交互的动画
        return interactive.isInteracting ? interactive : nil
    }
    

}

class CustomAnimator:NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.35
    func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // fromVc 总是获取到正在显示在屏幕上的Controller
        let fromVc = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey)!
        // toVc 总是获取到将要显示的controller
        let toVc = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey)!
        // why optional or when it will be nil ?
        let containView = transitionContext.containerView()
        
        let toView: UIView
        let fromView: UIView
        
        if transitionContext.responds(to:NSSelectorFromString("viewForKey:")) {
            // 通过这种方法获取到view不一定是对应controller.view
            toView = transitionContext.view(forKey: UITransitionContextToViewKey)!
            fromView = transitionContext.view(forKey: UITransitionContextFromViewKey)!
        } else {
            toView = toVc.view
            fromView = fromVc.view
        }
        //  添加toview到最上面(fromView是当前显示在屏幕上的view不用添加)
        containView.addSubview(toView)
        
        // 最终显示在屏幕上的controller的frame
        let visibleFrame = transitionContext.initialFrame(for: fromVc)
        // 隐藏在右边的controller的frame
        let rightHiddenFrame = CGRect(origin: CGPoint(x: visibleFrame.width, y: visibleFrame.origin.y) , size: visibleFrame.size)
        // 隐藏在左边的controller的frame
        let leftHiddenFrame = CGRect(origin: CGPoint(x: -visibleFrame.width, y: visibleFrame.origin.y) , size: visibleFrame.size)

        // toVc.presentingViewController --> 弹出toVc的controller
        // 所以如果是present的时候  == fromVc
        // 或者可以使用 fromVc.presentedViewController == toVc
        
        let isPresenting = toVc.presentingViewController == fromVc
        
        if isPresenting {// present Vc左移
            toView.frame = rightHiddenFrame
            fromView.frame = visibleFrame


        } else {// dismiss Vc右移
            fromView.frame = visibleFrame
            toView.frame = leftHiddenFrame
            // 有时需要将toView添加到fromView的下面便于执行动画
//            containView.insertSubview(toView, belowSubview: fromView)
        }
        

        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: {
            if isPresenting {
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
            // 通知系统动画是否完成或者取消了
            transitionContext.completeTransition(!cancelled)
        }
    }
}
