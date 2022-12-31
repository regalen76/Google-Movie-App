//
//  AdminHomeViewController.swift
//  MulmedFinalLab
//
//  Created by Reonaldo Galen Maliode on 29/12/22.
//

import UIKit
import CoreData

var movieList = [Moviedata]()

class AdminHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var firstLoad = true
    
    func nonDeletedMovies() -> [Moviedata]{
        var noDeleteMovieList = [Moviedata]()
        for movie in movieList{
            if movie.deletedDate == nil{
                noDeleteMovieList.append(movie)
            }
        }
        return noDeleteMovieList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initList()
        if(firstLoad){
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Moviedata")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let movie = result as! Moviedata
                    movieList.append(movie)
                }
            }catch{
                print("Fetch Failed")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        movieTableView.delegate = self
        movieTableView.delegate = self
        
        movieTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editMovieSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMovieSegue"{
            let indexPath = movieTableView.indexPathForSelectedRow!
            
            let movieDetail = segue.destination as? AdminMovieDetalViewController
            
            let selectedMovie : Moviedata!
            selectedMovie = nonDeletedMovies()[indexPath.row]
            movieDetail!.selectedMovie = selectedMovie
            
            movieTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func moveToDetail(_ sender: Any) {
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        movieList.removeAll()
        performSegue(withIdentifier: "unwindToLogin2", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedMovies().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID", for: indexPath) as! AdminMovieCell
        
        let thisMovie: Moviedata!
        thisMovie = nonDeletedMovies()[indexPath.row]
        
        tableViewCell.movieTitle.text = thisMovie.title
        tableViewCell.movieDesc.text = "Description: " + thisMovie.desc
        tableViewCell.movieGenre.text = "Genre: " + thisMovie.genre
        tableViewCell.movieLength.text = "Movie Length: " + thisMovie.length
        tableViewCell.movieReleaseDate.text = "Release Date: " + thisMovie.releasedate
        tableViewCell.movieRating.text = "Rating: " + "\(String(describing: thisMovie.rating!))"
        
        return tableViewCell
    }
    
    @IBAction func unwindToAdminHome(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
