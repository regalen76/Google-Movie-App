//
//  AdminMovieDetalViewController.swift
//  MulmedFinalLab
//
//  Created by Reonaldo Galen Maliode on 29/12/22.
//

import UIKit
import CoreData

class AdminMovieDetalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var genre: UITextField!
    @IBOutlet weak var length: UITextField!
    @IBOutlet weak var releasedate: UITextField!
    
    let genres = ["Romance", "Comedy", "Thriller", "Action", "Fantasy", "Sci-fi"]
    
    var selectedMovie: Moviedata? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //release date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        releasedate.inputView = datePicker
        
        //genre picker
        let viewPicker = UIPickerView()
        genre.inputView = viewPicker
        viewPicker.delegate = self
        viewPicker.dataSource = self
        
        if(selectedMovie != nil){
            titleText.text = selectedMovie!.title!
            descriptionText.text = selectedMovie!.desc!
            genre.text = selectedMovie!.genre!
            length.text = selectedMovie!.length!
            releasedate.text = selectedMovie!.releasedate!
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if selectedMovie == nil{
            let entity = NSEntityDescription.entity(forEntityName: "Moviedata", in: context)
            let newMovie = Moviedata(entity: entity!, insertInto: context)
            newMovie.id = movieList.count as NSNumber
            newMovie.title = titleText.text
            newMovie.desc = descriptionText.text
            newMovie.genre = genre.text
            newMovie.length = length.text
            newMovie.releasedate = releasedate.text
            newMovie.rating = 0
            do{
                try context.save()
                movieList.append(newMovie)
                performSegue(withIdentifier: "unwindToAdminHome", sender: self)
            }catch{
                print("context save error")
            }
        }else{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Moviedata")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let movie = result as! Moviedata
                    if movie == selectedMovie{
                        movie.title = titleText.text
                        movie.desc = descriptionText.text
                        movie.genre = genre.text
                        movie.length = length.text
                        movie.releasedate = releasedate.text
                        movie.rating = 0
                        try context.save()
                        performSegue(withIdentifier: "unwindToAdminHome", sender: self)
                    }
                }
            }catch{
                print("Fetch Failed")
            }
        }
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Moviedata")
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let movie = result as! Moviedata
                if movie == selectedMovie{
                    movie.deletedDate = Date()
                    try context.save()
                    performSegue(withIdentifier: "unwindToAdminHome", sender: self)
                }
            }
        }catch{
            print("Fetch Failed")
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        performSegue(withIdentifier: "unwindToAdminHome", sender: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genres.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genres[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genre.text = genres[row]
        genre.resignFirstResponder()
    }
    
    @objc func dateChange(datePicker: UIDatePicker){
        releasedate.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter.string(from: date)
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
