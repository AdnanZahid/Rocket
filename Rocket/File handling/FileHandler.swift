//
//  FileHandler.swift
//  Rocket
//
//  Created by Adnan Zahid on 23/05/2020.
//  Copyright © 2020 Rocket. All rights reserved.
//

import Foundation

class FileHandler {

  static func contentsOfFile(fileName: String) -> String {
    var contents = ""
    do { contents = try String(contentsOfFile: fileName) }
    catch {}
    return contents
  }
}
