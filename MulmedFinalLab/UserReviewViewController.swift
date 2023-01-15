//
//  UserReviewViewController.swift
//  MulmedFinalLab
//
//  Created by Reonaldo Galen Maliode on 31/12/22.
//

import UIKit
import CoreData

class UserReviewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate{

    var userReviewList = [Moviereview]()
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descText: UILabel!
    @IBOutlet weak var genreText: UILabel!
    @IBOutlet weak var lengthText: UILabel!
    @IBOutlet weak var releaseText: UILabel!
    @IBOutlet weak var ratingText: UILabel!
    
    @IBOutlet weak var reviewTableView: UITableView!
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var ratingChoose: UITextField!
    let ratings = ["1 out of 5", "2 out of 5", "3 out of 5", "4 out of 5", "5 out of 5"]
    
    var selectedMovie: Moviedata? = nil
    
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(firstLoad){
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Moviereview")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let review = result as! Moviereview
                    if review.id == selectedMovie?.id{
                        userReviewList.append(review)
                    }
                }
            }catch{
                print("Fetch Failed")
            }
        }
        
        if selectedMovie != nil{
            titleText.text = "Title: \(String(describing: selectedMovie!.title!))"
            descText.text = "Description: \(String(describing: selectedMovie!.desc!))"
            genreText.text = "Genre: \(String(describing: selectedMovie!.genre!))"
            lengthText.text = "Length: \(String(describing: selectedMovie!.length!))"
            releaseText.text = "Release Date: \(String(describing: selectedMovie!.releasedate!))"
            ratingText.text = "Rating: \(String(describing: selectedMovie!.rating!))"
        }
        
        //rating picker
        let viewPicker = UIPickerView()
        ratingChoose.inputView = viewPicker
        viewPicker.delegate = self
        viewPicker.dataSource = self
    }
    
    @IBAction func postBtn(_ sender: Any) {
        if reviewTextView.text!.isEmpty || ratingChoose.text! == "Rating:"{
            let alertVC = UIAlertController(title: "Warning", message: "Fields cannot be empty", preferredStyle: .alert)
            let action = UIAlertAction (title: "OK", style: .default)
            alertVC.addAction(action)
            present(alertVC, animated: true)
        }else{
            if reviewTextView.text!.count < 15{
                let alertVC = UIAlertController(title: "Warning", message: "Reviews must contains more than 15 characters", preferredStyle: .alert)
                let action = UIAlertAction (title: "OK", style: .default)
                alertVC.addAction(action)
                present(alertVC, animated: true)
            }else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Moviereview", in: context)
                let newReview = Moviereview(entity: entity!, insertInto: context)
                newReview.id = selectedMovie?.id
                
                let defaults = UserDefaults.standard
                newReview.usernow = defaults.string(forKey: "userKey")
                
                newReview.review = reviewTextView.text
                if ratingChoose.text == "Rating: 1 out of 5"{
                    newReview.rating = 1
                }else if ratingChoose.text == "Rating: 2 out of 5"{
                    newReview.rating = 2
                }else if ratingChoose.text == "Rating: 3 out of 5"{
                    newReview.rating = 3
                }else if ratingChoose.text == "Rating: 4 out of 5"{
                    newReview.rating = 4
                }else if ratingChoose.text == "Rating: 5 out of 5"{
                    newReview.rating = 5
                }
                do{
                    try context.save()
                    userReviewList.append(newReview)
                    
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Moviedata")
                    do{
                        let results:NSArray = try context.fetch(request) as NSArray
                        for result in results {
                            let movie = result as! Moviedata
                            if movie == selectedMovie{
                                movie.title = selectedMovie?.title
                                movie.desc = selectedMovie?.desc
                                movie.genre = selectedMovie?.genre
                                movie.length = selectedMovie?.length
                                movie.releasedate = selectedMovie?.releasedate
                                
                                var a: Float = 0
                                var b: Float = 0
                                var c: Float = 0
                                var d: Float = 0
                                var e: Float = 0
                                for i in userReviewList{
                                    if i.rating == 1{
                                        a += 1
                                    }else if i.rating == 2{
                                        b += 1
                                    }else if i.rating == 3{
                                        c += 1
                                    }else if i.rating == 4{
                                        d += 1
                                    }else if i.rating == 5{
                                        e += 1
                                    }
                                }
                                let r: Float = a+b+c+d+e
                                a = a*1
                                b = b*2
                                c = c*3
                                d = d*4
                                e = e*5
                                var ar:Float = a+b+c+d+e
                                ar = ar/r
                                movie.rating = NSNumber(value: ar)
                                ratingText.text = "Rating: \(movie.rating!)"
                                
                                try context.save()
                            }
                        }
                    }catch{
                        print("Fetch Failed")
                    }
                    
                    reviewTableView.delegate = self
                    reviewTableView.delegate = self
                    reviewTableView.reloadData()
                }catch{
                    print("context save error")
                }
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        performSegue(withIdentifier: "unwindToUserHome", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userReviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID", for: indexPath) as! UserReviewCell
        
        tableViewCell.layer.borderWidth = 2.0
        tableViewCell.layer.borderColor = UIColor.white.cgColor
        tableViewCell.layer.cornerRadius = 15
        
        let thisReview: Moviereview!
        thisReview = userReviewList[indexPath.row]
        
        tableViewCell.userText.text = "User: \(String(describing: thisReview!.usernow!))"
        tableViewCell.ratingText.text = "Rating: \(String(describing: thisReview!.rating!))"
        tableViewCell.reviewText.text = "Review: \(String(describing: thisReview!.review!))"
        
        return tableViewCell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratings.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ratings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ratingChoose.text = "Rating: \(ratings[row])"
        ratingChoose.resignFirstResponder()
    }

}
