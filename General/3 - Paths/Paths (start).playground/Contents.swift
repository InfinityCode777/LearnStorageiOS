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
import Foundation

//FileManager.documentDirectoryURL
//
//print(FileManager.documentDirectoryURL)


let mysteryBytes: [UInt8] = [
    240,          159,          152,          184,
    240,          159,          152,          185,
    0b1111_0000,  0b1001_1111,  0b1001_1000,  186,
    0xF0,         0x9F,         0x98,         187
]

// Way #1 of creating an URL (w/o extension)
let mysteryDataURL = URL(fileURLWithPath: "mysteryData", relativeTo: FileManager.documentDirectoryURL)
mysteryDataURL.path

// Way #2 of creating an URL (w/ extension)
let stringURL = FileManager.documentDirectoryURL.appendingPathComponent("string").appendingPathExtension("txt")
stringURL.path
// Create another URL (w/ extension)
var challengeString = "Gemini"
var challengeStringURL: URL = FileManager.documentDirectoryURL.appendingPathComponent(challengeString).appendingPathExtension("txt")

// Get the path from URL
var challengeStringPath = challengeStringURL.path

// This will return the file name a.k.a. the last path component for given URL
var fileName = challengeStringURL.lastPathComponent


// You can save bytes to a file w/o extension, bytes -> Data() -> file
let mysteryData = Data(bytes: mysteryBytes)
do {
    try  mysteryData.write(to: mysteryDataURL)
} catch {
    print("Error >> \(error.localizedDescription)")
}

var savedMysteryData = Data()

// Retrieve data from file, file -> Data()
do {
    savedMysteryData = try Data(contentsOf: mysteryDataURL)
} catch {
    print("Error >> \(error.localizedDescription)")
}

print("savedMysteryData = \(savedMysteryData)")

// Convert fetched data to bytes, Data() -> bytes
let savedMysteryBytes = Array(savedMysteryData)


// Then you can compare the original bytes with fetched bytes
savedMysteryBytes == mysteryBytes
// Then you can compare the original data with fetched data
savedMysteryData == mysteryData


// You can save data to a file w/ extension, Data() -> file
do {
    try  mysteryData.write(to: mysteryDataURL.appendingPathExtension("txt"))
} catch {
    print("Error >> \(error.localizedDescription)")
}

// Decode from, Data -> String rather than, Data -> bytes
let savedMysteryString = String(bytes: savedMysteryData, encoding: .utf8)
//try? savedMysteryString?.write(to: stringURL, atomically: true, encoding: .utf8)

// Decode from, file -> String rather than file -> Data -> String
let savedString = try? String(contentsOf: stringURL, encoding: .utf8)
print("savedString = \(savedString ?? "")")

// Convert String -> Data
let challengingData = challengeString.data(using: .utf8) ?? Data()
// Then you can save data to a file to a given URL, Data -> file,
try? challengingData.write(to: challengeStringURL)
// Decode from, file -> String rather than file -> Data -> String
let readChallengString = try String(contentsOf: challengeStringURL, encoding: .utf8)
//let readChallengString = String(bytes: challengingData, encoding: .utf8)
