//
//  ViewController.swift
//  Flixster - Assignment 01 & 02 - FINAL
//
//  Created by Madison Shimbo on 9/26/21.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                self.tableView.reloadData() // after requesting movie data, it will call the two below functions
                // print(dataDictionary)


             }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // function asking for number of row
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // asking for cell in particular row given and prints data for every row stated in function above
        // if a cell if off screen, give it to be
        // recycled and if none avalible create new
        // cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)// combines base Url and posterPath
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // (the function is for preparation from leaving from one screen and navigating to (preparing) a new page)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Loading up the details screen")
        
        // Find the selected movie (sender = cell that was tapped on -> cell tapped on is the movie we are targetting)
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)! // gets index path of given cell
        let movie = movies[indexPath.row]
        // Get the new view controller using segue.destination & pass the selected object to the new view controller.
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie // movie for new page is movie we saved data about
        // deselect what we clicked on so it doesn't keep getting highlighted
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

