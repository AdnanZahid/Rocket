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

  struct IrisModel: Layer {
    var layer1 = Dense<Float>(inputSize: Constants.inputLayerSize, outputSize: Constants.hiddenLayerSize, activation: relu)
    var layer2 = Dense<Float>(inputSize: Constants.hiddenLayerSize, outputSize: Constants.hiddenLayerSize, activation: relu)
    var layer3 = Dense<Float>(inputSize: Constants.hiddenLayerSize, outputSize: Constants.outputLayerSize)

    @differentiable
    func callAsFunction(_ input: Tensor<Float>) -> Tensor<Float> {
      return input.sequenced(through: layer1, layer2, layer3)
    }
  }

  private enum Constants {
    static let iterationDataFile = "IterationData.csv"
    static let batchSize = 1
    static let inputLayerSize = 4
    static let hiddenLayerSize = 10
    static let outputLayerSize = 2
  }

  private var model = IrisModel()
  private let trainDataset = Dataset(contentsOfCSVFile: Constants.iterationDataFile,
                                     hasHeader: true,
                                     featureColumns: [0, 1, 2, 3],
                                     labelColumns: [4]).batched(Constants.batchSize)

  func predict(distance: CGFloat,
               upperBound: CGFloat,
               lowerBound: CGFloat,
               yPosition: CGFloat) -> Bool {
    guard let features = trainDataset.first?.features,
          let labels = trainDataset.first?.labels else { return false }
    let predictions = model(features)
    let normalizedPredictions = predictions.argmax(squeezingAxis: 1)
//    print(predictions)
//    print(predictions.argmax(squeezingAxis: 1))
    let optimizer = SGD(for: model, learningRate: 0.01)
    let (_, grads) = valueWithGradient(at: model) { model -> Tensor<Float> in
      return softmaxCrossEntropy(logits: predictions, labels: labels)
    }
    optimizer.update(&model, along: grads)
//    let shouldJump = Bool.random()
    let integerPrediction = normalizedPredictions.scalars.first
    let shouldJump = integerPrediction == 0 ? false : true
    return shouldJump
  }

  func write(distance: CGFloat,
             upperBound: CGFloat,
             lowerBound: CGFloat,
             yPosition: CGFloat,
             shouldJump: Bool) {
    let shouldJumpInteger = shouldJump ? 1 : 0
    FileHandler.write(to: Constants.iterationDataFile,
                      content: "\(distance),\(upperBound),\(lowerBound),\(yPosition),\(shouldJumpInteger)\n")

//    print("\(distance),\(upperBound),\(lowerBound),\(yPosition),\(shouldJumpInteger)")
  }
}
