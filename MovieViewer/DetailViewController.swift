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
    @IBOutlet weak var ratingLabel: UILabel!

    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var backdropView: UIImageView!
    
    @IBOutlet weak var popLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
   
    var movies : NSDictionary!
    var genres1 : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y+infoView.frame.height)
        
        self.navigationItem.title = "Movie Details"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor=UIColor.blue
        
        let title = movies["title"] as? String
        titleLabel.text = title?.uppercased()
        
        let overview = movies["overview"]
        overviewLabel.text = overview as? String
        
       
        let rating = movies["vote_average"] as! Float
        ratingLabel.text = String(describing: rating)
        
        let pop = movies["popularity"] as! Int
        popLabel.text = String(describing: "\(pop)%")
        //let releaseDate = movies["release_date"] as! String
        //releaseDateLabel.text = String(describing: releaseDate)
        
        let releaseDate = movies["release_date"] as! String
        
        let myDate = releaseDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: myDate)!
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let dateString = dateFormatter.string(from: date)
        releaseDateLabel.text = String(describing: dateString)
        
        if let genreIDs = movies?.object(forKey: "genre_ids") as? [Int]
        {
            print(genreIDs)
            //var gLabel = genreLabel.text
             //   gLabel = String(describing: genreIDs)
            
            //let genreid = genres1["id"] as? [Int]
            //print("palak \(genreid)")
            
            //print("palak \(self.genres1)")

        }
        else{
            
        }
        
 

        overviewLabel.sizeToFit()
        let baseUrl = "https://image.tmdb.org/t/p/w500/"

        if let posterPath = movies["poster_path"] as? String {
            let imageRequest = NSURL(string: baseUrl + posterPath)
            collectionPosterView.setImageWith(imageRequest as! URL)
        }
        if let backdrop = movies["backdrop_path"] as? String {
            let imageRequest = NSURL(string: baseUrl + backdrop)
            backdropView.setImageWith(imageRequest as! URL)
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
