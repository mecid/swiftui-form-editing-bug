//
//  Sleep.swift
//  SleepBot
//
//  Created by Majid Jabrayilov on 6/16/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

struct Sleep: Identifiable, Hashable {
    let id: UUID
    var inBedInterval: DateInterval
    var asleepIntervals: [DateInterval]
    let userDefined: Bool
}

extension Sleep {
    static let mock = Sleep(
        id: .init(),
        inBedInterval: .today,
        asleepIntervals: [
            .init(start: Date(), duration: 100),
            .init(start: Date(), duration: 200)
        ],
        userDefined: true
    )
}

extension DateInterval {
    static var today: DateInterval {
        return Calendar.current.dateInterval(of: .day, for: .init())!
    }
}
