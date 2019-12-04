//
//  BaseDataHandler.swift
//  VideoPlayer
//
//  Created by Muneer KK on 29/11/19.
//  Copyright © 2019 Muneer KK. All rights reserved.
//

import Foundation
class BaseDataHandler: NSObject {
    //MARK: - Common completetionblock for DataHandler classes
    internal typealias DataHandlerCompletionBlock = (_ errorObject : NSError?) -> ()
    internal typealias DataHandlerDataCompletionBlock = (_ responseObject : Any?, _ errorObject : NSError?) -> ()
}
