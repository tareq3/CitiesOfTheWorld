//
//  ListViewController.swift
//  CitiesOfTheWorld
//
//  Created by Tareq on 10/12/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mySegmentedOutlet: UISegmentedControl!
    lazy var mainVC : MainViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var vc = storyBoard.instantiateViewController(withIdentifier: "MainViewControllerID") as! MainViewController
        
        self.addViewControllerAsChildViewController(childViewController: vc)
        return vc
    }()
    lazy var mapVC : MapViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var vc = storyBoard.instantiateViewController(withIdentifier: "MapViewControllerID") as! MapViewController
        
        self.addViewControllerAsChildViewController(childViewController: vc)
        return vc
    }()
    @IBAction func mySegmentControl(_ segment: UISegmentedControl) {
        mainVC.view.isHidden = true
        mapVC.view.isHidden  = true
        
        if segment.selectedSegmentIndex == 0 {
            mainVC.view.isHidden = false
        }else{
            mapVC.view.isHidden = false
            mapVC.updateMarker()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        addChild(mainVC)
        addChild(mapVC)
        self.view.addSubview(mainVC.view)
        self.view.addSubview(mapVC.view)
        
        mainVC.didMove(toParent: self)
        mapVC.didMove(toParent: self)
        mainVC.view.frame = self.view.bounds
        mapVC.view.frame = self.view.bounds
        mapVC.view.isHidden = true
        
    }
    
    
    private func addViewControllerAsChildViewController(childViewController : UIViewController){
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        childViewController.didMove(toParent: self)
    }
}
