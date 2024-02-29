//
// movenet_singlepose_thunder_4.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
class movenet_singlepose_thunder_4Input : MLFeatureProvider {
    
    /// input as color (kCVPixelFormatType_32BGRA) image buffer, 256 pixels wide by 256 pixels high
    var input: CVPixelBuffer
    
    var featureNames: Set<String> {
        get {
            return ["input"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "input") {
            return MLFeatureValue(pixelBuffer: input)
        }
        return nil
    }
    
    init(input: CVPixelBuffer) {
        self.input = input
    }
    
    convenience init(inputWith input: CGImage) throws {
        self.init(input: try MLFeatureValue(cgImage: input, pixelsWide: 256, pixelsHigh: 256, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!)
    }
    
    convenience init(inputAt input: URL) throws {
        self.init(input: try MLFeatureValue(imageAt: input, pixelsWide: 256, pixelsHigh: 256, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!)
    }
    
    func setInput(with input: CGImage) throws  {
        self.input = try MLFeatureValue(cgImage: input, pixelsWide: 256, pixelsHigh: 256, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
    }
    
    func setInput(with input: URL) throws  {
        self.input = try MLFeatureValue(imageAt: input, pixelsWide: 256, pixelsHigh: 256, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
    }
    
}


/// Model Prediction Output Type
@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
class movenet_singlepose_thunder_4Output : MLFeatureProvider {
    
    /// Source provided by CoreML
    private let provider : MLFeatureProvider
    
    /// Identity as multidimensional array of floats
    var Identity: MLMultiArray {
        return self.provider.featureValue(for: "Identity")!.multiArrayValue!
    }
    
    /// Identity as multidimensional array of floats
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    var IdentityShapedArray: MLShapedArray<Float> {
        return MLShapedArray<Float>(self.Identity)
    }
    
    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }
    
    init(Identity: MLMultiArray) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["Identity" : MLFeatureValue(multiArray: Identity)])
    }
    
    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
class movenet_singlepose_thunder_4 {
    let model: MLModel
    
    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let resPath =  Bundle(for: self).url(forResource: "movenet_singlepose_thunder_4", withExtension:"mlmodel")!
        return try! MLModel.compileModel(at: resPath)
    }
    
    /**
     Construct movenet_singlepose_thunder_4 instance with an existing MLModel object.
     
     Usually the application does not use this initializer unless it makes a subclass of movenet_singlepose_thunder_4.
     Such application may want to use `MLModel(contentsOfURL:configuration:)` and `movenet_singlepose_thunder_4.urlOfModelInThisBundle` to create a MLModel object to pass-in.
     
     - parameters:
     - model: MLModel object
     */
    init(model: MLModel) {
        self.model = model
    }
    
    /**
     Construct a model with configuration
     
     - parameters:
     - configuration: the desired model configuration
     
     - throws: an NSError object that describes the problem
     */
    convenience init(configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }
    
    /**
     Construct movenet_singlepose_thunder_4 instance with explicit path to mlmodelc file
     - parameters:
     - modelURL: the file url of the model
     
     - throws: an NSError object that describes the problem
     */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }
    
    /**
     Construct a model with URL of the .mlmodelc directory and configuration
     
     - parameters:
     - modelURL: the file url of the model
     - configuration: the desired model configuration
     
     - throws: an NSError object that describes the problem
     */
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }
    
    /**
     Construct movenet_singlepose_thunder_4 instance asynchronously with optional configuration.
     
     Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
     
     - parameters:
     - configuration: the desired model configuration
     - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
     */
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<movenet_singlepose_thunder_4, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }
    
    /**
     Construct movenet_singlepose_thunder_4 instance asynchronously with optional configuration.
     
     Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
     
     - parameters:
     - configuration: the desired model configuration
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> movenet_singlepose_thunder_4 {
        return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }
    
    /**
     Construct movenet_singlepose_thunder_4 instance asynchronously with URL of the .mlmodelc directory with optional configuration.
     
     Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
     
     - parameters:
     - modelURL: the URL to the model
     - configuration: the desired model configuration
     - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
     */
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<movenet_singlepose_thunder_4, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(movenet_singlepose_thunder_4(model: model)))
            }
        }
    }
    
    /**
     Construct movenet_singlepose_thunder_4 instance asynchronously with URL of the .mlmodelc directory with optional configuration.
     
     Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
     
     - parameters:
     - modelURL: the URL to the model
     - configuration: the desired model configuration
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> movenet_singlepose_thunder_4 {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return movenet_singlepose_thunder_4(model: model)
    }
    
    /**
     Make a prediction using the structured interface
     
     - parameters:
     - input: the input to the prediction as movenet_singlepose_thunder_4Input
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as movenet_singlepose_thunder_4Output
     */
    func prediction(input: movenet_singlepose_thunder_4Input) throws -> movenet_singlepose_thunder_4Output {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }
    
    /**
     Make a prediction using the structured interface
     
     - parameters:
     - input: the input to the prediction as movenet_singlepose_thunder_4Input
     - options: prediction options 
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as movenet_singlepose_thunder_4Output
     */
    func prediction(input: movenet_singlepose_thunder_4Input, options: MLPredictionOptions) throws -> movenet_singlepose_thunder_4Output {
        let outFeatures = try model.prediction(from: input, options:options)
        return movenet_singlepose_thunder_4Output(features: outFeatures)
    }
    
    /**
     Make an asynchronous prediction using the structured interface
     
     - parameters:
     - input: the input to the prediction as movenet_singlepose_thunder_4Input
     - options: prediction options 
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as movenet_singlepose_thunder_4Output
     */
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    func prediction(input: movenet_singlepose_thunder_4Input, options: MLPredictionOptions = MLPredictionOptions()) async throws -> movenet_singlepose_thunder_4Output {
        let outFeatures = try await model.prediction(from: input, options:options)
        return movenet_singlepose_thunder_4Output(features: outFeatures)
    }
    
    /**
     Make a prediction using the convenience interface
     
     - parameters:
     - input as color (kCVPixelFormatType_32BGRA) image buffer, 256 pixels wide by 256 pixels high
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as movenet_singlepose_thunder_4Output
     */
    func prediction(input: CVPixelBuffer) throws -> movenet_singlepose_thunder_4Output {
        let input_ = movenet_singlepose_thunder_4Input(input: input)
        return try self.prediction(input: input_)
    }
    
    /**
     Make a batch prediction using the structured interface
     
     - parameters:
     - inputs: the inputs to the prediction as [movenet_singlepose_thunder_4Input]
     - options: prediction options 
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as [movenet_singlepose_thunder_4Output]
     */
    func predictions(inputs: [movenet_singlepose_thunder_4Input], options: MLPredictionOptions = MLPredictionOptions()) throws -> [movenet_singlepose_thunder_4Output] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [movenet_singlepose_thunder_4Output] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  movenet_singlepose_thunder_4Output(features: outProvider)
            results.append(result)
        }
        return results
    }
}
