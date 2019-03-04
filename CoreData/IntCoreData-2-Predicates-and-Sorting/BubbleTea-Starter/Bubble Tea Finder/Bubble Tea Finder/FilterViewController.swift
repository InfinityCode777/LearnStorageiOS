/**
 * Copyright (c) 2016 Razeware LLC
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

protocol FilterViewControllerDelegate: class {
  func filterViewController(filter: FilterViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?)
}

class FilterViewController: UITableViewController {
  
  @IBOutlet weak var firstPriceCategoryLabel: UILabel!
  @IBOutlet weak var secondPriceCategoryLabel: UILabel!
  @IBOutlet weak var thirdPriceCategoryLabel: UILabel!
  @IBOutlet weak var numDealsLabel: UILabel!
  
  // MARK: - Price section
  @IBOutlet weak var cheapVenueCell: UITableViewCell!
  @IBOutlet weak var moderateVenueCell: UITableViewCell!
  @IBOutlet weak var expensiveVenueCell: UITableViewCell!
  
  // MARK: - Most popular section
  @IBOutlet weak var offeringDealCell: UITableViewCell!
  
  // MARK: - Sort section
  @IBOutlet weak var nameAZSortCell: UITableViewCell!
  @IBOutlet weak var nameZASortCell: UITableViewCell!
  
  // MARK: - Properties
  var coreDataStack: CoreDataStack!
  weak var delegate: FilterViewControllerDelegate?
  var selectedSortDescriptor: NSSortDescriptor?
  var selectedPredicate: NSPredicate?
  
  lazy var offeringDealPredicate: NSPredicate = {
    return NSPredicate(format: "%K > 0", #keyPath(Venue.specialCount))
  }()
  
  private lazy var nameSortAZDescriptor: NSSortDescriptor = {
    return NSSortDescriptor(key: #keyPath(Venue.name),  ascending: true)
  }()
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    populateCheapVenueCountLabel()
    //    populateModerateVenueCountLabel()
    //    populateExpensiveVenueCountLabel()
    var commonText = " bubble tea place(s)"
    firstPriceCategoryLabel.text = "\(getVenueCount(for: "$"))" + commonText
    secondPriceCategoryLabel.text = "\(getVenueCount(for: "$$"))" + commonText
    thirdPriceCategoryLabel.text = "\(getVenueCount(for: "$$$"))" + commonText
    
    commonText = " total deal(s)"
    numDealsLabel.text = "\(getDealsCount())" + commonText
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    //    delegate?.filterViewController(filter: self, didSelectPredicate: nil, sortDescriptor: nil)
    //    dismiss(animated: true)
  }
  
  
  private func getPredicate(for priceCategory: String) -> NSPredicate {
    return NSPredicate(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), priceCategory)
  }
  
  
}

// MARK: - IBActions
extension FilterViewController {
  
  @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    delegate?.filterViewController(filter: self, didSelectPredicate: selectedPredicate, sortDescriptor: selectedSortDescriptor)
    dismiss(animated: true)
  }
}

// MARK: - UITableViewDelegate
extension FilterViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    
    switch cell {
    case cheapVenueCell:
      selectedPredicate = getPredicate(for: "$")
    case moderateVenueCell:
      selectedPredicate = getPredicate(for: "$$")
    case expensiveVenueCell:
      selectedPredicate = getPredicate(for: "$$$")
      
    // Most Popular section
    case offeringDealCell:
      selectedPredicate = offeringDealPredicate
    case nameAZSortCell:
      selectedSortDescriptor = nameSortAZDescriptor
    case nameZASortCell:
      selectedSortDescriptor = nameSortAZDescriptor.reversedSortDescriptor as? NSSortDescriptor
      
    default: break
    }
    
    cell.accessoryType = .checkmark
  }
}

// MARK: - Helper methods
extension FilterViewController {
  
  func populateCheapVenueCountLabel() {
    
  }
  
  func populateModerateVenueCountLabel() {
    
  }
  
  func populateExpensiveVenueCountLabel() {
    
  }
  
  func getVenueCount(for priceCategry: String) -> Int {
    
    var count: Int = 0
    let fetchContext = coreDataStack.managedContext
    //    let fetchRequest = Venue.fetchRequest() as NSFetchRequest<Venue> //Way#1
    let fetchRequest: NSFetchRequest<Venue> = Venue.fetchRequest() //Way#2
    fetchRequest.predicate = getPredicate(for: priceCategry)
    
    do {
      //      count = try fetchContext.fetch(fetchRequest).count //Way#1
      count = try fetchContext.count(for: fetchRequest) //Way#2
    } catch {
      print("Fetching venue info failed! >> \(error)")
    }
    
    
    //    var count: Int = 0
    //    let fetchContext = coreDataStack.managedContext
    //        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Venue")
    //        fetchRequest.resultType = .countResultType
    //    fetchRequest.predicate = getPredicate(for: priceCategry)
    //
    //    do {
    //      let countResult = try fetchContext.fetch(fetchRequest).first?.intValue
    //      count = countResult ?? 0
    //    } catch {
    //      print("Fetching venue info failed! >> \(error)")
    //    }
    
    
    return count
  }
  
  
  
  
  func getDealsCount() -> Int {
    
    var count: Int = 0
    let fetchContext = coreDataStack.managedContext
    let fetchRequest: NSFetchRequest<Venue> = Venue.fetchRequest()
    fetchRequest.predicate = offeringDealPredicate
    
    do {
      count = try fetchContext.fetch(fetchRequest).count //Way#1
    } catch {
      print("Fetching venue info failed! >> \(error)")
    }
    return count
  }
  
  
  
  
}
