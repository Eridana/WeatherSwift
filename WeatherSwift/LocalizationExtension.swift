//
//  LocalizationExtension.swift
//  GourmetPilot2
//
//  Created by Evgeniya Mikhailova on 28.05.18.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import UIKit

extension String {
    public var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
