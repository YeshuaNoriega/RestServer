//  887863686
//  Yeshua Noriega
//  Problem 3


import Kitura
import Cocoa

let router = Router()


router.get("/"){
    request, response, next in
    response.send("Hello! Welcome to the Claim service. ")
    next()
}


router.post("/ClaimService/add") {
    request, response, next in
    let body = request.body
    let jObj = body?.asJSON
    if let jDict = jObj as? [String:String] {
        if let titleIN = jDict["Title"],let dateIN = jDict["Date"] {
            let uuid = UUID().uuidString
            let pObjIN = Claim(identity : uuid, ti : titleIN, da : dateIN)
            ClaimDao().addClaim(pObj: pObjIN)
        }
    }
    response.send("The Claim record was successfully inserted (via POST Method, format JSON).")
    next()
}


router.get("PersonService/getAll"){
    request, response, next in
    let pList = ClaimDao().getAll()
    let jsonData : Data = try JSONEncoder().encode(pList)
    let jsonStr = String(data: jsonData, encoding: .utf8)
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    next()
}



Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()
