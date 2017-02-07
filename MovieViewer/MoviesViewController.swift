//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Palak Jadav on 1/29/17.
//  Copyright © 2017 flounderware. All rights reserved.
//
import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,
    UISearchBarDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionPosterView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var myView: UIView!
    
    var movies : [NSDictionary]?
    var filteredData: [NSDictionary]?
    var searchController: UISearchController!
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self

        if Reachability.isInternetAvailable() == true {
            print("Internet connection OK")
        } else {
            internetConnectionFailure()
        }
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        // add refresh control to collection view
        collectionView.insertSubview(refreshControl, at:0)
        self.loadData()
    }
    func addSubview(_ view: UIView)
    {
     let testFrame : CGRect = CGRect(x: 0, y: 67, width: 400, height: 44)
     let testView : UIView = UIView(frame: testFrame)
     testView.backgroundColor = UIColor(patternImage: UIImage(named: "noInternet4.png")!)
     testView.alpha=1
     self.view.addSubview(testView)
    }
    
    func internetConnectionFailure() {
        print("Internet connection FAILED")
        let testFrame : CGRect = CGRect(x: 0, y: 67, width: 400, height: 44)
        let testView : UIView = UIView(frame: testFrame)
        testView.backgroundColor = UIColor(patternImage: UIImage(named: "noInternet4.png")!)
        testView.alpha=1
        self.view.addSubview(testView)
    }
    
    func loadData() {
        if Reachability.isInternetAvailable() == true
        {
            print("Internet connection OK Refresh")
            let apiKey = "77bc664c8b8d2989ffcfed882e4cb784"
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            
            // Configure session so that completion handler is executed on main UI thread
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        self.movies = dataDictionary["results"]as? [NSDictionary]
                        self.filteredData = self.movies
                        self.collectionView.reloadData()
                    }
                }
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            task.resume()
        }
        else
        {
            internetConnectionFailure()
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.loadData()
        refreshControl.endRefreshing()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return filteredData?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionMovieCell", for: indexPath) as! CollectionMovieCell
        let movie =  filteredData![indexPath.row]
        //let baseUrl = "https://image.tmdb.org/t/p/w500/"

        let smallImageUrl = "https://image.tmdb.org/t/p/w45/"
        let largeImageUrl = "https://image.tmdb.org/t/p/original"
        
        /*if let posterPath = movie["poster_path"] as? String {
            let imageRequest = NSURLRequest(url: NSURL(string: baseUrl + posterPath)! as URL)
            
            cell.collectionPosterView.setImageWith(imageRequest as URLRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.collectionPosterView.alpha = 0.0
                    cell.collectionPosterView.image = image
                    UIView.setAnimationsEnabled(true)
                    UIView.animate(withDuration: 2, animations: { () -> Void in
                        cell.collectionPosterView.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.collectionPosterView.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                                                    print("error")
            })
        }*/
        
        let posterPath = movie["poster_path"] as? String
        let smallImageRequest = NSURLRequest(url: NSURL(string: smallImageUrl + posterPath!)! as URL)
        let largeImageRequest = NSURLRequest(url: NSURL(string: largeImageUrl + posterPath!)! as URL)
        
        cell.collectionPosterView.setImageWith(
            smallImageRequest as URLRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                cell.collectionPosterView.alpha = 0.0
                cell.collectionPosterView.image = smallImage;
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    
                    cell.collectionPosterView.alpha = 1.0
                    print("Low Resolution Image Loading")
                }, completion: { (sucess) -> Void in
                    
                    // The AFNetworking ImageView Category only allows one request to be sent at a time
                    // per ImageView. This code must be in the completion block.
                    cell.collectionPosterView.setImageWith(
                        largeImageRequest as URLRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            cell.collectionPosterView.image = largeImage;
                            print("High Resolution Image Loading")
                            
                    },
                        failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                    })
                })
        },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? movies : movies?.filter({(movie: NSDictionary) -> Bool in
            let title = movie["title"] as! String
            self.filteredData=self.movies
            // If dataItem matches the searchText, return true to include it
            return title.range(of: searchText, options: .caseInsensitive) != nil
        })
        self.collectionView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("segue")
        
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movies = movie
        
    }
}
