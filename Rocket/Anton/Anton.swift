//
//  Anton.swift
//  Rocket
//
//  Created by Mnet on 5/23/20.
//  Copyright © 2020 Rocket. All rights reserved.
//

import Foundation
import TensorFlow

class Anton {

  struct GameParameters {
    let features: Tensor<Float>
    let labels: Tensor<Int32>
  }

  private enum Constants {
    static let iterationDataFile = "IterationData.csv"
  }

  private let batchSize = 32
  private let trainDataset: Dataset<GameParameters>?

  init() {
    trainDataset = Dataset(
      contentsOfCSVFile: Constants.iterationDataFile,
      hasHeader: true,
      featureColumns: [0, 1, 2, 3],
      labelColumns: [4]
    ).batched(batchSize)
  }

  func predict(distance: CGFloat,
               upperBound: CGFloat,
               lowerBound: CGFloat,
               yPosition: CGFloat) -> Bool {
    let shouldJump = Bool.random()
    return shouldJump
  }

  func write(distance: CGFloat,
             upperBound: CGFloat,
             lowerBound: CGFloat,
             yPosition: CGFloat,
             shouldJump: Bool) {
    let shouldJumpInteger = shouldJump ? 1.0 : 0.0
    FileHandler.write(to: Constants.iterationDataFile,
                      content: "\(distance),\(upperBound),\(lowerBound),\(yPosition),\(shouldJumpInteger)\n")
  }
}
