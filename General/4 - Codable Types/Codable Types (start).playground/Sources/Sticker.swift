
import UIKit
public struct Sticker: Codable, Equatable {
    
    public let name: String
    public let birthday: Date?
    public let normalizedPosition: CGPoint
    public let imageName: String
    public var image: UIImage? { return Image.getPNGFromDocumentDirectory(kind: .sticker, name: imageName) }
    
    
    public init(name: String, birthday: Date?, normalizedPosition: CGPoint, imageName: String) {
        self.name = name
        self.birthday = birthday
        self.normalizedPosition = normalizedPosition
        self.imageName = imageName
    }
}
