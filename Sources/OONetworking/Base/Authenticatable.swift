//
//  Authenticatable
//  
//
//  Created by Eric Cartmenez on 15/06/2020.
//  Copyright © 2020 Eric Cartmenez. All rights reserved.
//

import Foundation

// Authentication base protocol.
public protocol Authenticatable {

	var needsAuthentication: Bool { get }

}
