/**
 * Copyright (c) 2018 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData

class MainViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context: NSManagedObjectContext? = {
        return appDelegate?.persistentContainer.viewContext
    }()
    
    private var fetchedRC = NSFetchedResultsController<Friend>()
    private var isFiltered = false
    private var friendPets = [Pet]()
    private var selected:IndexPath!
    private var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
//        loadData(with: nil)
//        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData(with: nil)
        collectionView.reloadData()
//        collectionView.reloadInputViews()
        showEditButton()
    }
    
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "petSegue" {
            if let index = sender as? IndexPath {
                let pvc = segue.destination as! PetsViewController
                let friend = fetchedRC.object(at: index)
                
//                if !friend.name.isEmpty {
//                    if let pets = friend.pets as? [Pet] {
//                        pvc.pets = pets
//
//                    }
//                    pvc.petAdded = {
//                        self.friendPets[friend.name] = pvc.pets
//                    }
                
//                }
                pvc.friend = friend

            }
        }
    }
    
    // MARK:- Actions
    @IBAction func addFriend() {
        
        
        
        
        let friendData = FriendData()
        let friendEntry = Friend(entity: Friend.entity(), insertInto: context)
        friendEntry.name = friendData.name
        friendEntry.address = friendData.address
        friendEntry.dob = friendData.dob as NSDate
        friendEntry.eyecolor = friendData.eyeColor
        
        appDelegate?.saveContext()
        
        loadData(with: nil)
        collectionView.reloadData()
        
    }
    
    // MARK:- Private Methods
    private func showEditButton() {
        
        guard let itemCount = fetchedRC.fetchedObjects?.count else {
            print("Early return, no available item for editing")
            return
        }
        
        if itemCount > 0 {
            navigationItem.leftBarButtonItem = editButtonItem
        }
    }
}

// Collection View Delegates
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fetchedRC.object
        // Jing's Way
        guard let fetchedSection = fetchedRC.sections?[section] else {
            print("Early return, empty section, return 0 row!")
            return 0
        }
        
        let numOfObjects = fetchedSection.numberOfObjects
        
        return numOfObjects
        
        //        // Demo way
        //        guard let sections = fetchedRC.sections, let objs = sections[section].objects else { return 0 }
        //
        //        return objs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let numOfSections = fetchedRC.sections?.count else {
            print("Early return, empty fetched result, return 1 section!")
            return 0
        }
        return numOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let friend = fetchedRC.object(at: indexPath)
        var profilePhoto: UIImage? = UIImage(named: "person-placeholder")
        
        if !friend.name.isEmpty {
            cell.nameLabel.text = friend.name
            if let photoData = friend.photo as Data? {
                profilePhoto = UIImage(data: photoData)
            }
        }
        
        cell.pictureImageView.image = profilePhoto
        
        cell.addressLabel.text = friend.address
        
        if let age = friend.age {
            cell.ageLabel.text = "Age: \(age)"
        } else {
            cell.ageLabel.text = "Age: Unknown"
        }
        cell.eyeColorView.backgroundColor = friend.eyecolor as? UIColor
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditing {
            selected = indexPath
            self.navigationController?.present(picker, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "petSegue", sender: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderRow", for: indexPath)
        
        var indicationEyeColor: UIColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)

        var colorString = ""

        if let friends = fetchedRC.sections?[indexPath.section].objects as? [Friend], let eyeColor = friends.first?.eyecolor as? UIColor{
            indicationEyeColor = eyeColor
            colorString = String(describing: friends.first?.eyeColor)
            print("EyeColor >> \(colorString)")
        }
//
        if let headerView = view as? HeaderCell {
            headerView.eyeColorIndicator.tintColor = indicationEyeColor
            print("Expected indicator color to \(colorString)")
            print("Expected indicator color to \(headerView.eyeColorIndicator.tintColor)")
        }
        
        return view
    }
    
}

// Search Bar Delegate
extension MainViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Search bar resigns its first responder status
        searchBar.resignFirstResponder()
        
        // Return if search content is nil or empty
        guard let queryText = searchBar.text else {
            print("Early return, search result is nil!")
            return
        }
        
        if queryText.isEmpty {
            print("Early return, search result is empty!")
            return
        }
        
        // Set flag to indicate that current results are filtered results
        isFiltered = true
        
        // Load filtered results with query content
        //        guard let friends = loadData(with: queryText) else {
        //            return
        //        }
        loadData(with: queryText)
        
        //        self.friends = friends
        
        // Refresh collection view
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // Search bar resigns its first responder status
        searchBar.resignFirstResponder()
        
//        // Clear flag to indicate that current results are un-filtered results
//        isFiltered = false
        
        loadData(with: nil)
        
        // Clear search bar content
        searchBar.text = nil
        
        // Refresh collection view
        collectionView.reloadData()
    }
    
    private func loadData(with query: String?) {
        
        // Check that there is a valid context
        guard let fetchContext = self.context else { return }
        
        let fetchRequest = Friend.fetchRequest() as NSFetchRequest<Friend>
        
        if let queryText = query {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", queryText)
        }
        //        let sortDescriptorList = [NSSortDescriptor(key: #keyPath(Friend.name), ascending: false)]
        //                let sortDescriptorList = [NSSortDescriptor(key: #keyPath(Friend.dob), ascending: true)]
        //        let sortDescriptorList = [NSSortDescriptor(key: #keyPath(Friend.name), ascending: true, comparator: )]
        let sortName = NSSortDescriptor(key: #keyPath(Friend.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        let sortEyeColor = NSSortDescriptor(key: #keyPath(Friend.eyecolor),  ascending: true)
        
        
        fetchRequest.sortDescriptors = [sortEyeColor, sortName]
        
        fetchedRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: fetchContext, sectionNameKeyPath: #keyPath(Friend.eyecolor), cacheName: nil)
        
        
        do {
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Error, could not fetch data! >> \(error) ")
        }
        
    }
}

// Image Picker Delegates
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage  else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        let friend = fetchedRC.object(at: selected)
        friend.photo = image.pngData() as NSData?
        
        appDelegate?.saveContext()
        collectionView?.reloadItems(at: [selected])
        picker.dismiss(animated: true, completion: nil)
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
