/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import ReSwift

enum RoutingDestination: String {
  case menu = "MenuTableViewController"
  case categories = "CategoriesTableViewController"
  case game = "GameViewController"
}

final class AppRouter {
    
  let navigationController: UINavigationController
    
  init(window: UIWindow) {
    navigationController = UINavigationController()
    window.rootViewController = navigationController
    // 1
    store.subscribe(self) {
      $0.select {
        $0.routingState
      }
    }
  }
  
  // 2
  fileprivate func pushViewController(identifier: String, animated: Bool) {
    let viewController = instantiateViewController(identifier: identifier)
    let newViewControllerType = type(of: viewController)
    
    if let currentVc = navigationController.topViewController {
      let currentViewControllerType = type(of: currentVc)
      if currentViewControllerType == newViewControllerType {
        return
      }
    }
    
    navigationController.pushViewController(viewController, animated: animated)
  }
    
  private func instantiateViewController(identifier: String) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: identifier)
  }
}

// MARK: - StoreSubscriber
// 3
extension AppRouter: StoreSubscriber {
  func newState(state: RoutingState) {
    // 4
    let shouldAnimate = navigationController.topViewController != nil
    // 5
    pushViewController(identifier: state.navigationState.rawValue, animated: shouldAnimate)
  }
}
