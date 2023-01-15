//
//  UserHomeViewController.swift
//  MulmedFinalLab
//
//  Created by Reonaldo Galen Maliode on 30/12/22.
//

import UIKit
import CoreData

class UserHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var movie : [Moviedata] = []
    
    @IBOutlet weak var movieTableView: UITableView!
    
    @IBOutlet weak var filterText: UITextField!
    let genres = ["All", "Romance", "Comedy", "Thriller", "Action", "Fantasy", "Sci-fi"]
    var genrePickerView = UIPickerView()
    
    @IBOutlet weak var sortText: UITextField!
    let sorts = ["Default", "Rating", "Released Date"]
    var sortPickerView = UIPickerView()
    
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
        
        //genres picker
        filterText.inputView = genrePickerView
        genrePickerView.delegate = self
        genrePickerView.dataSource = self
        genrePickerView.tag = 1
        
        //sorts picker
        sortText.inputView = sortPickerView
        sortPickerView.delegate = self
        sortPickerView.dataSource = self
        sortPickerView.tag = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        movieTableView.delegate = self
        movieTableView.delegate = self
        movieTableView.reloadData()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        movieList.removeAll()
        performSegue(withIdentifier: "unwindToLoginUser", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "userReviewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userReviewSegue"{
            let indexPath = movieTableView.indexPathForSelectedRow!
            
            let userReview = segue.destination as? UserReviewViewController
            
            let selectedMovie : Moviedata!
            selectedMovie = nonDeletedMovies()[indexPath.row]
            userReview!.selectedMovie = selectedMovie
            
            movieTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return genres.count
        case 2:
            return sorts.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return genres[row]
        case 2:
            return sorts[row]
        default:
            return "Data not found."
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            filterText.text = "Filter by: \(genres[row])"
            filterText.resignFirstResponder()
            
            movieList.removeAll()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Moviedata")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let movie = result as! Moviedata
                    if("Filter by: \(movie.genre!)" == filterText.text!){
                        movieList.append(movie)
                    }else if(filterText.text! == "Filter by: All"){
                        movieList.append(movie)
                    }
                }
            }catch{
                print("Fetch Failed")
            }
            
            if(sortText.text == "Sort by: Released Date"){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd yyyy"
                
                let test = movieList.sorted {dateFormatter.date(from: $0.releasedate)! > dateFormatter.date(from: $1.releasedate)!}
                movieList = test
            }else if(sortText.text == "Sort by: Rating"){
                movieList = movieList.sorted { (Float(truncating: $0.rating) ) > (Float(truncating: $1.rating) ) }
            }
            
            movieTableView.delegate = self
            movieTableView.delegate = self
            movieTableView.reloadData()
        case 2:
            sortText.text = "Sort by: \(sorts[row])"
            sortText.resignFirstResponder()
            
            if(sortText.text == "Sort by: Released Date"){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd yyyy"
                
                let test = movieList.sorted {dateFormatter.date(from: $0.releasedate)! > dateFormatter.date(from: $1.releasedate)!}
                movieList = test
            }else if(sortText.text == "Sort by: Rating"){
                movieList = movieList.sorted { (Float(truncating: $0.rating) ) > (Float(truncating: $1.rating) ) }
            }else{
                movieList.removeAll()
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Moviedata")
                do{
                    let results:NSArray = try context.fetch(request) as NSArray
                    for result in results {
                        let movie = result as! Moviedata
                        if("Filter by: \(movie.genre!)" == filterText.text!){
                            movieList.append(movie)
                        }else if(filterText.text! == "Filter by: All"){
                            movieList.append(movie)
                        }
                    }
                }catch{
                    print("Fetch Failed")
                }
            }
            
            movieTableView.delegate = self
            movieTableView.delegate = self
            movieTableView.reloadData()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedMovies().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID", for: indexPath) as! UserMovieCell
        
        let thisMovie: Moviedata!
        
        tableViewCell.layer.borderWidth = 2.0
        tableViewCell.layer.borderColor = UIColor.white.cgColor
        tableViewCell.layer.cornerRadius = 15
        
        thisMovie = nonDeletedMovies()[indexPath.row]
        
        tableViewCell.movieTitle.text = thisMovie.title
        tableViewCell.movieDesc.text = "Description: " + thisMovie.desc
        tableViewCell.movieGenre.text = "Genre: " + thisMovie.genre
        tableViewCell.movieLength.text = "Movie Length: " + thisMovie.length
        tableViewCell.movieReleaseDate.text = "Release Date: " + thisMovie.releasedate
        tableViewCell.movieRating.text = "Rating: " + "\(String(describing: thisMovie.rating!))"
        
        return tableViewCell
    }
    
    @IBAction func unwindToUserHome(_ unwindSegue: UIStoryboardSegue) {
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
