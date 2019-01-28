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

struct JImage: Decodable {
    enum Kind: String, Decodable {
        case scene
        case sticker
    }
    
    enum DecodingError: Error {
        case missingFile
    }
    
    var name: String
    var kind: Kind
    var pngData: Data
    
//    init(fileName: String) throws {
//        guard let url =  Bundle.main.url(forResource: fileName, withExtension: "json") else {
//            throw DecodingError.missingFile
//        }
//
//        let decoder = JSONDecoder()
//        let data = try Data(contentsOf: url)
//        self = try decoder.decode(JImage.self, from: data)
////        let image = try decoder.decode(JImage.self, from: data)
////        self.kind = image.kind
////        self.name = image.name
////        self.pngDtata = image.pngDtata
//
//    }
    
    
}

//let jImage = try JImage(fileName: "image")
//UIImage(data: jImage.pngData)


extension Array where Element == JImage {
    init(fileName: String) throws {
        guard let url =  Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw JImage.DecodingError.missingFile
        }
        
        let decoder = JSONDecoder()
        let data = try Data(contentsOf: url)
        self = try decoder.decode([JImage].self, from: data)
        
    }
}

let jImageList = try [JImage](fileName: "images")
let imageList = jImageList.map( {UIImage(data: $0.pngData)})



