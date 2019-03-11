/*
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

class AttachPhotoViewController: UIViewController {
  
  // MARK: - Properties
  var note : Note?
  lazy var imagePicker : UIImagePickerController = {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    picker.delegate = self
    self.addChild(picker)
    return picker
  }()
  
  private lazy var stack: CoreDataStack = CoreDataStack(modelName:"UnCloudNotesDataModel")
  
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addChild(imagePicker)
    view.addSubview(imagePicker.view)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    imagePicker.view.frame = view.bounds
  }
}

// MARK: - UIImagePickerControllerDelegate
extension AttachPhotoViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    
    // Local variable inserted by Swift 4.2 migrator.
    let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
    let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
    
//    // Original
//    guard let note = note else { return }
//    note.image = image
    
    //    // Jing's way, does not work
    //    guard let note = note else { return }
    //    guard let noteContext = note.managedObjectContext else { return }
    //
    //
    //    let attachment = Attachment(context: noteContext)
    //    attachment.dateCreated = note.dateCreated
    //    attachment.image = image
    //    attachment.note = note
    //
    
    //    let attachment =  Attachment(entity: Attachment.entity(), insertInto: stack.managedContext)
    //    let attachment = Attachment(context: stack.managedContext)
    
    
        //Tutorial
        guard let note = note,
          let context = note.managedObjectContext else { return }

        let attachment = Attachment(context: context)
        attachment.dateCreated = Date()
        attachment.image = image
        attachment.note = note
    
    _ = navigationController?.popViewController(animated: true)
  }
}

// MARK: - UINavigationControllerDelegate
extension AttachPhotoViewController: UINavigationControllerDelegate {
}

// MARK: - NoteDisplayable
extension AttachPhotoViewController: NoteDisplayable {
}








// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
  return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
  return input.rawValue
}
