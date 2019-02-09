/*:
 Copyright (c) 2018 Razeware LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 distribute, sublicense, create a derivative work, and/or sell copies of the
 Software in any work that is designed, intended, or marketed for pedagogical or
 instructional purposes related to programming, coding, application development,
 or information technology.  Permission for such use, copying, modification,
 merger, publication, distribution, sublicensing, creation of derivative works,
 or sale is expressly withheld.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 ---
 */
import UIKit
//import Foundation

// Tutorial: https://www.raywenderlich.com/6307-saving-data-in-ios/lessons/12

for image in try! [Image](fileName: "images") {
  try! image.save(directory: .documentDirectory)
}

//try! [Image](fileName: "images").count

//FileManager.documentDirectoryURL




let catSticker = Sticker(name: "David Meowie",
                      birthday: DateComponents(calendar: .current, year: 1978, month: 3, day: 12).date!,
                      normalizedPosition: CGPoint(x: 0.3, y: 0.3),
                      imageName: "cat")

let dogSticker = Sticker(name: "Cute Dog",
                        birthday: DateComponents(calendar: .current, year: 1986, month: 5, day: 27).date!,
                        normalizedPosition: CGPoint(x: 0.5, y: 0.5),
                        imageName: "dog")

let frogSticer = Sticker(name: "Power Frog",
                        birthday: DateComponents(calendar: .current, year: 1996, month: 1, day: 8).date!,
                        normalizedPosition: CGPoint(x: 1.5, y: 1.5),
                        imageName: "frog")

// Check the loaded image if you'd like to
//catSticker.image


let stickerList = [catSticker, dogSticker, frogSticer]


do {
    let jsonURL = URL(fileURLWithPath: catSticker.name,
                      relativeTo: FileManager.documentDirectoryURL.appendingPathComponent(Image.Kind.sticker.rawValue)).appendingPathExtension("json")
    
    print("URL = \(jsonURL)")
    print("URL.path = \(jsonURL.path)")
    print("URL.lastPathComponent = \(jsonURL.lastPathComponent)")
    
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    let jsonData = try jsonEncoder.encode(catSticker)
    try jsonData.write(to: jsonURL)
    
    let jsonDecoder = JSONDecoder()
    let savedJSONData = try Data(contentsOf: jsonURL)
    let savedCatSticker = try jsonDecoder.decode(Sticker.self, from: savedJSONData)
    
    savedCatSticker == catSticker

    
} catch {
    print("Error >> \(error.localizedDescription)")
}


do {
    let jsonURL = URL(fileURLWithPath: "Animals",
                      relativeTo: FileManager.documentDirectoryURL.appendingPathComponent(Image.Kind.sticker.rawValue)).appendingPathExtension("json")
    
//    print("URL = \(jsonURL)")
//    print("URL.path = \(jsonURL.path)")
//    print("URL.lastPathComponent = \(jsonURL.lastPathComponent)")
//
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    let jsonData = try jsonEncoder.encode(stickerList)
    try jsonData.write(to: jsonURL)

    let jsonDecoder = JSONDecoder()
    let savedJSONData = try Data(contentsOf: jsonURL)
    let savedAnimalSticker = try jsonDecoder.decode([Sticker].self, from: savedJSONData)

    savedAnimalSticker == stickerList
    
    // Check the results
    savedAnimalSticker.map( {$0.image})
    
    
} catch {
    print("Error >> \(error.localizedDescription)")
}
