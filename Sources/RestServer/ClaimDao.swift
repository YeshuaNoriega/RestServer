//  Yeshua Noriega 887863686 yeshua1z.n@csu.fullerton.edu
//  ClaimDao.swift
//  RestServer
//
//  Created by yeshua z noriega long on 10/25/20.
//

import SQLite3
struct Claim : Codable {
    var id : String?
    var title : String?
    var date : String?
    var isSolved : Int?
    
    init(identity : String?, ti : String?, da : String?) {
        id = identity
        title = ti
        date = da
        isSolved = 0
    }
    
    init(identity : String?, ti : String?, da : String?, sol : Int?) {
        id = identity
        title = ti
        date = da
        isSolved = sol
    }
}


import SQLite3
class ClaimDao {
    
    
    func addClaim(pObj : Claim) {
        let sqlStmt = String(format: "Insert into claim (title, date) values ('%@', '%@')", (pObj.title)!, (pObj.date)!)
        let conn = Database.getInstance().getDbConnection()
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("failed to insert a claim record due to error \(errcode)")
        }
        sqlite3_close(conn)
    }
    
    
    func getAll() -> [Claim] {
        var pList = [Claim]()
        var resultSet : OpaquePointer?
        let sqlStr = "select id, title, date, isSolved from claim"
        let conn = Database.getInstance().getDbConnection()
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSet, nil) == SQLITE_OK {
            while(sqlite3_step(resultSet) == SQLITE_ROW){
                let id_val = sqlite3_column_text(resultSet, 0)
                let id = String(cString: id_val!)
                let title_val = sqlite3_column_text(resultSet, 1)
                let title = String(cString: title_val!)
                let date_val = sqlite3_column_text(resultSet, 2)
                let date = String(cString: date_val!)
                let solved_val = sqlite3_column_int(resultSet, 3)
                let solved = Int(solved_val)
                pList.append(Claim(identity : id, ti : title, da : date, sol : solved))
            }
        }
            
        return pList
    }
}
