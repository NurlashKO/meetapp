import SwiftyJSON

class UserObject {

    var ID: String!
    var UserName: String!
    var PositionX: Double!
    var PositionY: Double!

    required init(json: JSON) {
        UserName = json["UserName"].stringValue
        PositionX = json["PositionX"].doubleValue
        PositionY = json["PositionY"].doubleValue
    }
}