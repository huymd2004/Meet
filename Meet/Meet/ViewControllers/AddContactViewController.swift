//
//  AddContactViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow
import SwiftFlowRouter

class AddContactViewController: UIViewController, StoreSubscriber {

    static let identifier = "AddContactViewController"

    @IBOutlet var locationIndicatorView: LocationIndicatorView!
    var store = mainStore
    var twitterAPIActionCreator = TwitterAPIActionCreator()
    var locationServiceActionCreator = LocationServiceActionCreator()

    override func viewDidLoad() {
        locationIndicatorView.locationServiceRequestedCallback = { [unowned self] view in
            self.store.dispatch( self.locationServiceActionCreator.retrieveLocation(true) )
        }
    }

    override func viewWillAppear(animated: Bool) {
        store.subscribe(self)
        store.dispatch( locationServiceActionCreator.retrieveLocation(false) )
    }

    func newState(maybeState: StateType) {
        guard let state = maybeState as? AppState else { return }

        if let currentLocationResult = state.locationServiceState.currentLocation {
            switch currentLocationResult {
            case .Success(let location):
                locationIndicatorView.displayState = .Located(location.geocodedAddress)
            case .Failure(let error):
                break
            }
        } else if state.locationServiceState.busyLocating == true {
            locationIndicatorView.displayState = .BusyLocating
        } else if state.locationServiceState.authorizationStatus == .NotDetermined {
            locationIndicatorView.displayState = .LocationAuthorizationRequired
        }
    }

    @IBAction func emailIntroButtonTapped(sender: AnyObject) {
//        let emailIntroViewController = UIStoryboard(name: "Main",bundle: nil)
//            .instantiateViewControllerWithIdentifier("EmailIntroViewController")

        store.dispatch(CreateContactFromEmail("Benjamin.Encz@gmail.com"))
    }

    @IBAction func addTwitterButtonTapped(sender: AnyObject) {
        // TODO: Should not be instantiated here
        store.dispatch ( self.twitterAPIActionCreator.authenticateUser() ) { state in
            if let state = state as? HasTwitterAPIState {
                if state.twitterAPIState.swifter != nil {
                    self.store.dispatch (
                        SetRouteAction(["TabBarViewController", AddContactViewController.identifier,
                            SearchTwitterViewController.identifier])
                    )
                }
            }
        }
    }
}

extension AddContactViewController: Routable {

    func pushRouteSegment(routeElementIdentifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable {

            if (routeElementIdentifier == SearchTwitterViewController.identifier) {
                let searchTwitterViewController = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewControllerWithIdentifier("SearchTwitterViewController") as! SearchTwitterViewController
                presentViewController(searchTwitterViewController, animated: true,
                    completion: completionHandler)
                return searchTwitterViewController
            }

        abort()
    }

    func popRouteSegment(routeElementIdentifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) {

            dismissViewControllerAnimated(true, completion: completionHandler)
    }

}
