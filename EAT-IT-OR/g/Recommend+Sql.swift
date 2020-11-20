//
//  Recommend+Sql.swift
//  EAT-IT-Project
//
//  Created by admin on 02/07/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import Foundation
import SQLite3

extension Recommend{
    
static func createTable(database: OpaquePointer?){
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS RECOMMENDS (ST_ID TEXT PRIMARY KEY, OWNER_ID TEXT, OWNER_NAME TEXT, TITLE TEXT, LOCATION TEXT, DESCRIPTION TEXT, IMAGE TEXT, LAST_UPDATE DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    func upsertToDb(){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(ModelSql.instance.database,"INSERT OR REPLACE INTO RECOMMENDS(ST_ID , OWNER_ID, OWNER_NAME, TITLE , LOCATION, DESCRIPTION, IMAGE, LAST_UPDATE) VALUES (?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let id = self.id.cString(using: .utf8)
            let ownerId = self.ownerId.cString(using: .utf8)
            let ownerName = self.ownerName.cString(using: .utf8)
            let title = self.title.cString(using: .utf8)
            let location = self.location.cString(using: .utf8)
            let description = self.description.cString(using: .utf8)
            let image = self.image.cString(using: .utf8)
            
            let lastUpdated = self.lastUpdate ?? 0
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, ownerId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, ownerName,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, title,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, location,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, description,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 7, image,-1,nil);
            sqlite3_bind_int64(sqlite3_stmt, 8, lastUpdated);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully - up")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    func deleteFromDb(){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(ModelSql.instance.database,"DELETE FROM RECOMMENDS WHERE ST_ID=?;",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let id = self.id.cString(using: .utf8)
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("row was deleted succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllRecommendFromDb()->[Recommend]{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Recommend]()
        
        if (sqlite3_prepare_v2(ModelSql.instance.database,"SELECT * from RECOMMENDS ORDER BY LAST_UPDATE DESC;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                let recId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let ownerId = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                
                let recommend = Recommend(id: recId, ownerId: ownerId);
                
                recommend.ownerName = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                recommend.title = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                recommend.location = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                recommend.description = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                recommend.image = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
                
                data.append(recommend)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func getUserRecommendFromDb(uid: String)->[Recommend]{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Recommend]()
        
        if (sqlite3_prepare_v2(ModelSql.instance.database,"SELECT * FROM RECOMMENDS WHERE OWNER_ID = ? ORDER BY LAST_UPDATE DESC;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            
            let ownerId = uid.cString(using: .utf8)
            sqlite3_bind_text(sqlite3_stmt, 1, ownerId,-1,nil);
            
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                let recId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let ownerId = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                
                let recommend = Recommend(id: recId, ownerId: ownerId);
                
                recommend.ownerName = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                recommend.title = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                recommend.location = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                recommend.description = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                recommend.image = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
                
                data.append(recommend)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func setLastUpdate(lastUpdated:Int64){
        return ModelSql.instance.setLastUpdate(name: "RECOMMENDS", lastUpdated: lastUpdated);
    }
    
    static func getLastUpdateDate()->Int64{
        return ModelSql.instance.getLastUpdateDate(name: "RECOMMENDS")
    }
}

//    static func create_table(database: OpaquePointer?) {
//
//        var errormsg: UnsafeMutablePointer<Int8>? = nil
//        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS RECOMMENDATIONS (ST_ID TEXT PRIMARY KEY, OWNERID TEXT , OWNERNAME TEXT, TITLE TEXT , LOCATION TEXT, IMAGE TEXT, DESCRIPTION TEXT, LAST_UPDATE DOUBLE)", nil, nil, &errormsg);
//        if(res != 0){
//            print("error creating table");
//            return
//        }
//    }
//
//
//    func addToDb(){
//        var sqlite3_stmt: OpaquePointer? = nil
//        if (sqlite3_prepare_v2(ModelSql.instance.database,"INSERT OR REPLACE INTO RECOMMENDATIONS(ST_ID, OWNERID, OWNERNAME, TITLE, LOCATION, DESCRIPTION, IMAGE, LAST_UPDATE) VALUES (?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
//
//            let id = self.id.cString(using: .utf8)
//            let ownerId = self.ownerId.cString(using: .utf8)
//            let  ownerName = self.ownerName.cString(using: .utf8)
//            let title = self.title.cString(using: .utf8)
//            let  location = self.location.cString(using: .utf8)
//            let description = self.description.cString(using: .utf8)
//            let  image = self.image.cString(using: .utf8)
//            let  lastUpdated = self.lastUpdate ?? 0
//
//
//            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
//            sqlite3_bind_text(sqlite3_stmt, 2, ownerId,-1,nil);
//            sqlite3_bind_text(sqlite3_stmt, 3, ownerName,-1,nil);
//            sqlite3_bind_text(sqlite3_stmt, 4, title,-1,nil);
//            sqlite3_bind_text(sqlite3_stmt, 5, location,-1,nil);
//            sqlite3_bind_text(sqlite3_stmt, 6, description,-1,nil);
//            sqlite3_bind_text(sqlite3_stmt, 7, image,-1,nil);
//            sqlite3_bind_int64(sqlite3_stmt, 8, lastUpdated);
//
//            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
//                print("new row added succefully")
//            }
//        }
//        sqlite3_finalize(sqlite3_stmt)
//    }
//
//
//    func deleteFromDb(){
//        var sqlite3_stmt: OpaquePointer? = nil
//        if (sqlite3_prepare_v2(ModelSql.instance.database,"DELETE FROM RECOMMENDATIONS WHERE ST_ID=?;",-1, &sqlite3_stmt,nil) == SQLITE_OK){
//
//            let id = self.id.cString(using: .utf8)
//            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
//
//            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
//                print("row was deleted succefully")
//            }
//        }
//        sqlite3_finalize(sqlite3_stmt)
//    }
//
//
//    static func getUserRecommendFromDb(userId: String)->[Recommend]{
//        var sqlite3_stmt: OpaquePointer? = nil
//        var data = [Recommend]()
//
//        if (sqlite3_prepare_v2(ModelSql.instance.database,"SELECT * FROM RECOMMENDATIONS WHERE ST_ID = ? ORDER BY LAST_UPDATE DESC;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
//
//            let ownerId = userId.cString(using: .utf8)
//            sqlite3_bind_text(sqlite3_stmt, 1, ownerId,-1,nil);
//
//            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
//
//                let stId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
//                let ownerId = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
//
//                let recommend = Recommend(id: stId, ownerId: ownerId);
//
//                recommend.ownerName = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
//                recommend.title = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
//                recommend.location = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
//                recommend.description = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
//                recommend.image = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
//
//
//                data.append(recommend)
//            }
//        }
//        sqlite3_finalize(sqlite3_stmt)
//        return data
//    }
//
//
//    static func getAllRecommendFromDb()->[Recommend]{
//        var sqlite3_stmt: OpaquePointer? = nil
//        var data = [Recommend]()
//
//        if (sqlite3_prepare_v2(ModelSql.instance.database,"SELECT * from RECOMMENDATIONS ORDER BY LAST_UPDATE DESC;",-1,&sqlite3_stmt,nil)
//            == SQLITE_OK){
//            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
//
//                let stId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
//                let ownerId = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
//                let rc = Recommend(id: stId, ownerId: ownerId);
//
//                rc.ownerName = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
//                rc.title = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
//                rc.location = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
//                rc.description = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
//                rc.image = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
//                data.append(rc)
//            }
//        }
//        sqlite3_finalize(sqlite3_stmt)
//        return data
//    }
//
//    static func setLastUpdate(lastUpdated:Int64){
//        return ModelSql.instance.setLastUpdate(name: "RECOMMENDATIONS", lastUpdated: lastUpdated);
//    }
//
//    static func getLastUpdateDate()->Int64{
//        return ModelSql.instance.getLastUpdateDate(name: "RECOMMENDATIONS")
//    }
//
//}
