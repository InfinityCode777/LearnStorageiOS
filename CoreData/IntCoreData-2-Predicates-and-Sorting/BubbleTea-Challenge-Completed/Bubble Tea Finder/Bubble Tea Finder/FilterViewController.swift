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

  lazy var cheapVenuePredicate: NSPredicate = {
    return NSPredicate(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$")
  }()

  lazy var moderateVenuePredicate: NSPredicate = {
    return NSPredicate(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$$")
  }()

  lazy var expensiveVenuePredicate: NSPredicate = {
    return NSPredicate(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$$$")
  }()

  lazy var offeringDealPredicate: NSPredicate = {
    return NSPredicate(format: "%K > 0", #keyPath(Venue.specialCount))
  }()

  lazy var walkingDistancePredicate: NSPredicate = {
    return NSPredicate(format: "%K < 500", #keyPath(Venue.location.distance))
  }()

  lazy var hasUserTipsPredicate: NSPredicate = {
    return NSPredicate(format: "%K > 0", #keyPath(Venue.stats.tipCount))
  }()

  lazy var nameSortDescriptor: NSSortDescriptor = {
    let compareSelector = #selector(NSString.localizedStandardCompare(_:))
    return NSSortDescriptor(key: #keyPath(Venue.name),
                            ascending: true,
                            selector: compareSelector)
  }()

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    populateCheapVenueCountLabel()
    populateModerateVenueCountLabel()
    populateExpensiveVenueCountLabel()
    populateDealsCountLabel()
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

    guard let cell = tableView.cellForRow(at: indexPath)else {
      return
    }

    switch cell {
    // Price section
    case cheapVenueCell:
      selectedPredicate = cheapVenuePredicate
    case moderateVenueCell:
      selectedPredicate = moderateVenuePredicate
    case expensiveVenueCell:
      selectedPredicate = expensiveVenuePredicate

    // Most Popular section
    case offeringDealCell:
      selectedPredicate = offeringDealPredicate

    // Sort By section
    case nameAZSortCell:
      selectedSortDescriptor = nameSortDescriptor
    case nameZASortCell:
      selectedSortDescriptor = nameSortDescriptor.reversedSortDescriptor as? NSSortDescriptor

    default: break
    }

    cell.accessoryType = .checkmark
  }
}

// MARK: - Helper methods
extension FilterViewController {

  func populateCheapVenueCountLabel() {
    let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Venue")
    fetchRequest.resultType = .countResultType
    fetchRequest.predicate = cheapVenuePredicate

    do {
      let countResult = try coreDataStack.managedContext.fetch(fetchRequest)

      let count = countResult.first!.intValue
      firstPriceCategoryLabel.text = "\(count) bubble tea places"

    } catch let error as NSError {
      print("Count not fetch \(error), \(error.userInfo)")
    }
  }

  func populateModerateVenueCountLabel() {

    let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Venue")
    fetchRequest.resultType = .countResultType
    fetchRequest.predicate = moderateVenuePredicate

    do {

      let countResult = try coreDataStack.managedContext.fetch(fetchRequest)

      let count = countResult.first!.intValue
      secondPriceCategoryLabel.text = "\(count) bubble tea places"

    } catch let error as NSError {
      print("Count not fetch \(error), \(error.userInfo)")
    }
  }

  func populateExpensiveVenueCountLabel() {

    let fetchRequest: NSFetchRequest<Venue> = Venue.fetchRequest()
    fetchRequest.predicate = expensiveVenuePredicate

    do {
      let count = try coreDataStack.managedContext.count(for: fetchRequest)

      thirdPriceCategoryLabel.text = "\(count) bubble tea places"

    } catch let error as NSError {
      print("Count not fetch \(error), \(error.userInfo)")
    }
  }

  func populateDealsCountLabel() {

    //get a regular fetch request
    let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Venue")
    fetchRequest.resultType = .dictionaryResultType

    //create an expression description
    let sumExpressionDesc = NSExpressionDescription()
    sumExpressionDesc.name = "sumDeals"

    //the keypath we're running the expression on is Venue.specialCount
    let specialCountExp = NSExpression(forKeyPath: #keyPath(Venue.specialCount))
    
    //the sum expression description's expression is this nsexpression indicating the function
    //the arguments are the specialCountExp since we want to run the function on Venue.specialCount
    sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [specialCountExp])
    
    //return the answer as an int32
    sumExpressionDesc.expressionResultType = .integer32AttributeType

    //you build up this object and pass it in an array to propertiesToFetch
    fetchRequest.propertiesToFetch = [sumExpressionDesc]

    do {
      let results = try coreDataStack.managedContext.fetch(fetchRequest)
      let resultDict = results.first!
      let numDeals = resultDict["sumDeals"]!
      numDealsLabel.text = "\(numDeals) total deals"

    } catch let error as NSError {
      print("Count not fetch \(error), \(error.userInfo)")
    }
  }
}