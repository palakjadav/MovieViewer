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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,
    UISearchBarDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionPosterView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var myView: UIView!
    
    var movies : [NSDictionary]?
    var filterMovies: [[String: Any]]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.dataSource = self
        //tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        searchBar.delegate = self
        //filterMovies = movies?["title"] as! String
        
        if Reachability.isInternetAvailable() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let testFrame : CGRect = CGRect(x: 0, y: 67, width: 400, height: 44)
            let testView : UIView = UIView(frame: testFrame)
            testView.backgroundColor = UIColor(patternImage: UIImage(named: "noInternet4.png")!)
            testView.alpha=1
            self.view.addSubview(testView)
        }
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        //tableView.insertSubview(refreshControl, at: 0)
        
        // add refresh control to collection view
        collectionView.insertSubview(refreshControl, at:0)

        let apiKey = "77bc664c8b8d2989ffcfed882e4cb784"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    //print("response: \(dataDictionary)")
                    
                    self.movies = dataDictionary["results"]as? [NSDictionary]
                    //self.tableView.reloadData()
                    
                    self.collectionView.reloadData()
                }
            }
            
        // Hide HUD once the network request comes back (must be done on main UI thread)
        MBProgressHUD.hide(for: self.view, animated: true)
        }
        task.resume()
    }
    func addSubview(_ view: UIView) {
       /* CGRect.self;  viewRect = CGRectMake(10, 10, 100, 100);
        UIView*; myView = [[UIView, alloc] initWithFrame:viewRect];
        self.view.backgroundColor = UIColor.red
        var testView: UIView = UIView(frame: CGRectMake(0, 0, 320, 568))
        testView.backgroundColor = UIColor.red
        testView.alpha = 0.5
        testView.tag = 100
        super.view.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(testView)*/
     
     let testFrame : CGRect = CGRect(x: 0, y: 67, width: 400, height: 44)
     let testView : UIView = UIView(frame: testFrame)
     testView.backgroundColor = UIColor(patternImage: UIImage(named: "noInternet4.png")!)
     testView.alpha=1
     self.view.addSubview(testView)

    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        if Reachability.isInternetAvailable() == true {
            
            print("Internet connection OK Refresh")
            //testView.alpha=1
        
        let apiKey = "77bc664c8b8d2989ffcfed882e4cb784"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                   // print("response: \(dataDictionary)")
                    
                    self.movies = dataDictionary["results"]as? [NSDictionary]
                    //self.tableView.reloadData()
                    self.collectionView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        task.resume()
        }
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let movies = movies {
            return movies.count
        }
        else{
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionMovieCell", for: indexPath) as! CollectionMovieCell
        let movie =  movies![indexPath.row]
        //let title = [movie["title"] as! String]
                let baseUrl = "https://image.tmdb.org/t/p/w500/"
        
        if let posterPath = movie["poster_path"] as? String {
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
        }

        //let imageUrl = NSURL(string: baseUrl + posterPath)
        // new let imageRequest = NSURLRequest(url: NSURL(string: baseUrl + posterPath)! as URL)
        //cell.collectionPosterView.setImageWith(imageUrl as! URL)
        
      
        
        return cell
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /*self.filterMovies = self.movies?.filter({ (movie) -> Bool in
            return (movie["title"] as! String).range(of: searchText, options:.caseInsensitive, range: nil, locale: nil) != nil
        }) as! [[String : Any]]?*/
       /*filterMovies = searchText.isEmpty ? Data : data.filter({(dataString: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
             })*/
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let movies = movies {
        return movies.count
        }
        else{
        return 0
        }
        /*if let filteredData = filteredData {
            return filteredData.count
        }
        else{
            return 0
        }*/
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        as! MovieCell
        let movie =  movies![indexPath.row]
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w500/"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWith(imageUrl as! URL)
                return cell
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
