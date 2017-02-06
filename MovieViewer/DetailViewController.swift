//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Palak Jadav on 2/5/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    var movies : [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("segue")
        
        let cell=sender as! UICollectionView
        //let indexPath: NSIndexPath = self.collectionView.indexPathsForSelectedItems().first!
        //let selectedRow: NSManagedObject = locationsList[indexPath] as! NSManagedObject
        //let movie =  movies![indexPath!.row]
        
        let detailViewController = segue.destination
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
