//
//  NavigationReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

struct NavigationReducer {
  
  func navigateToViewController(var state: AppState, targetViewController: UIViewController) -> AppState {
    state.navigationState.currentViewController = targetViewController
    
    return state
  }
  
}