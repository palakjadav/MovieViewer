//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Palak Jadav on 2/5/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var collectionPosterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    var movies : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movies["title"] as? String
        titleLabel.text = title
        
        let overview = movies["overview"]
        overviewLabel.text = overview as? String
        print (movies)
        let baseUrl = "https://image.tmdb.org/t/p/w500/"

        if let posterPath = movies["poster_path"] as? String {
            let imageRequest = NSURL(string: baseUrl + posterPath)
            collectionPosterView.setImageWith(imageRequest as! URL)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
