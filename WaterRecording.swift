//
//  WaterRecording.swift
//  MyWater
//
//  Created by Panashe Muzangaza on 20/8/2022.
//

import Foundation

public struct WaterRecording : Decodable
{
    static let formatter = DateFormatter()
    
    public var time : String
    public var ManagedObjectid : Int
    public var typeM : String
    public var Series : String
    public var Unit : String
    public var Value : Int
    
    private var DateObj: Date?
    
    init(_ time: String, _ objectid: Int, _ typem: String, _ series: String, _ unit: String, _ value: Int)
    {
        self.time = time
        self.ManagedObjectid = objectid
        self.typeM = typem
        self.Series = series
        self.Unit = unit
        self.Value = value
        self.DateObj = GetDate(time)
    }
    
    public func GetDate(_ time: String) -> Date?
    {
        WaterRecording.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        WaterRecording.formatter.locale = Locale(identifier: "en_US_POSIX")
        return WaterRecording.formatter.date(from: time)
    }
    
    public func GetTime() -> String{
        if let safeDate = self.DateObj{
            WaterRecording.formatter.dateFormat = " hh:mm a "
            return WaterRecording.formatter.string(from: safeDate)
        }
        return ""

    }
}
