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

class PetsViewController: UIViewController {
	@IBOutlet private weak var collectionView:UICollectionView!
	
//    var petAdded:(()->Void)!
//    var pets = [String]()
//    var pets = [Pet]()
    var friend: Friend!
    
	private var selected:IndexPath!
	private var picker = UIImagePickerController()

    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context: NSManagedObjectContext? = {
        return appDelegate?.persistentContainer.viewContext
    }()
    
    private var fetchedRC = NSFetchedResultsController<Pet>()

    private var DOBFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DOBFormatter.dateFormat = "d MMM yyyy"
        picker.delegate = self
        loadData(with: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData(with: nil)
    }
    
	// MARK:- Actions
	@IBAction func addPet() {
		let petData = PetData()
        let petEntry = Pet(entity: Pet.entity(), insertInto: context)
        petEntry.name = petData.name
        petEntry.kind = petData.kind
        petEntry.dob = petData.dob as NSDate
        petEntry.owner = friend
        // By Jing, 2/28/19, can't do this since picture is Data? and an associated value is not provided during init
        //        petEntry.picture = petData.picture as NSData?
        // Save entity
        appDelegate?.saveContext()
        // Refresh UI
        loadData(with: nil)
        collectionView.reloadData()
	}
}

// Collection View Delegates
extension PetsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let pets = fetchedRC.fetchedObjects else {
            print("Early return, no pet in fetched result")
            return 0
        }
        
		return pets.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCell", for: indexPath) as! PetCell
		let pet = fetchedRC.object(at: indexPath)
        
        var profilePhoto: UIImage? = nil
        
        if !pet.name.isEmpty {
            cell.nameLabel.text = pet.name
        }

        if let photoData = pet.picture as Data? {
            profilePhoto = UIImage(data: photoData)
        } else {
            profilePhoto = UIImage(named: "pet-placeholder")
        }

        cell.pictureImageView.image = profilePhoto

		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selected = indexPath
        self.navigationController?.present(picker, animated: true, completion: nil)
        
	}
}

// Search Bar Delegate
extension PetsViewController:UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()

        
        
        guard let queryText = searchBar.text else {
            print("Early return, search result is nil!")
			return
		}
        
        if queryText.isEmpty {
            print("Early return, search result is empty!")
            return
        }

        loadData(with: queryText)
		collectionView.reloadData()
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = nil
		searchBar.resignFirstResponder()
        loadData(with: nil)
		collectionView.reloadData()
	}
    
    
    private func loadData(with query: String?) {
        
        // Check that there is a valid context
        guard let fetchContext = self.context else { return }
        
        let fetchRequest = Pet.fetchRequest() as NSFetchRequest<Pet>
        
        if let queryText = query {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@ AND owner = %@", queryText, friend)
        } else {
            fetchRequest.predicate = NSPredicate(format: "owner = %@", friend)
        }

        let sortName = NSSortDescriptor(key: #keyPath(Pet.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        
        
        fetchRequest.sortDescriptors = [sortName]
        
        fetchedRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: fetchContext, sectionNameKeyPath: nil, cacheName: nil)

        
        do {
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Error, could not fetch data! >> \(error) ")
        }
        
    }
}

// Image Picker Delegates
extension PetsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let petProfileImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            let pet = fetchedRC.object(at: selected)
            pet.picture = petProfileImage.pngData() as NSData?
            appDelegate?.saveContext()
            collectionView?.reloadItems(at: [selected])
        }
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
