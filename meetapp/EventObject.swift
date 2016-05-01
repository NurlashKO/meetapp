import SwiftyJSON

class EventObject {

    var eventID: Int!
    var eventName: String!
    var hostID: String!
    var description: String!
    var startTime: String!
    var positionX: Double!
    var positionY: Double!
    var tags: [String!]
    var connectedIDs: [String!]


    required init(json: JSON) {
        eventID = json["EventId"].intValue
        eventName = json["EventName"].stringValue
        hostID = json["HostId"].stringValue
        description = json["Description"].stringValue
        startTime = json["DateTime"].stringValue
        positionX = json["PositionX"].doubleValue
        positionY = json["PositionY"].doubleValue
        tags = json["Tags"].arrayValue.map {$0.string!}
        connectedIDs = json["ConnectedIds"].arrayValue.map {$0.string!}
    }
}