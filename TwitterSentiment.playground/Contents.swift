import Cocoa
import CreateML

let data = try MLDataTable(contentsOf: URL(fileURLWithPath:  "/Users/kgomara/Downloads/twitter-sanders-apple3.csv"))

let(trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)

let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

let evalutionMetrics = sentimentClassifier.evaluation(on: testingData)

let evaluationAccuracy = (1.0 - evalutionMetrics.classificationError)

let metadata = MLModelMetadata(author: "Kevin O'Mara", shortDescription: "A model trained to classify sentiment on Tweets", license: "MIT", version: "1.0")

try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/kgomara/Downloads/TweetSentimentClassifier.mlmodel"))

try sentimentClassifier.prediction(from: "Apple is a terrible company")
