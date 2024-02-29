import UIKit
import AVFoundation
import Vision
import Combine



func checkCameraAvailability() -> [String:Bool] {
    let videoDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                        mediaType: .video,
                                                        position: .unspecified).devices

    var hasFrontCamera = false
    var hasBackCamera = false

    for device in videoDevices {
        if device.position == .front {
            hasFrontCamera = true
        } else if device.position == .back {
            hasBackCamera = true
        }
    }
    
    return ["front":hasFrontCamera,"back":hasFrontCamera]
}







func resizePixelBuffer(_ pixelBuffer: CVPixelBuffer, width: Int, height: Int) -> CVPixelBuffer? {
    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
    let sx = CGFloat(width) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
    let sy = CGFloat(height) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
    let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
    let scaledImage = ciImage.transformed(by: scaleTransform)
    
    let context = CIContext()
    var resizedPixelBuffer: CVPixelBuffer?
    CVPixelBufferCreate(nil, width, height, CVPixelBufferGetPixelFormatType(pixelBuffer), nil, &resizedPixelBuffer)
    
    if let resizedPixelBuffer = resizedPixelBuffer {
        context.render(scaledImage, to: resizedPixelBuffer)
        return resizedPixelBuffer
    } else {
        return nil
    }
}


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate {
    var cancellables = Set<AnyCancellable>()
    @ObservedObject var sharedData = SharedData()
    var captureSession = AVCaptureSession()
    var previewView = UIImageView()
    var previewLayer:AVCaptureVideoPreviewLayer!
    var videoOutput:AVCaptureVideoDataOutput!
    var frameCounter = 0
    var frameInterval = 1
    var videoSize = CGSize.zero
    let ciContext = CIContext()
    
    lazy var modelRequest:VNCoreMLRequest! = {
        do {
            let model = try movenet_singlepose_thunder_4().model
            let vnModel = try VNCoreMLModel(for: model)
            let request = VNCoreMLRequest(model: vnModel)
            return request
        } catch let error {
            fatalError("mlmodel error.")
        }
    }()
    
    override func viewDidLoad() {
           super.viewDidLoad()
           setupCameraChangeObserver()

           
    }

    
    
       func setupCameraChangeObserver() {
           var deivceAvailabilityDic = checkCameraAvailability()
           //var deivceAvailabilityDic = ["front":false,"back":true]
           print(deivceAvailabilityDic)
           if(deivceAvailabilityDic["front"] == deivceAvailabilityDic["back"] && deivceAvailabilityDic["front"]!){
               sharedData.$useFrontCamera.sink { [weak self] useFrontCamera in
                   self?.setUpVideo(toFront: useFrontCamera)
               }.store(in: &cancellables) // 使用 Combine 框架，cancellables 為一個 Cancelable 類型的集合
           }else if(deivceAvailabilityDic["front"] != deivceAvailabilityDic["back"]){
               sharedData.$useFrontCamera.sink { [weak self] useFrontCamera in
                   self?.setUpVideo(toFront: deivceAvailabilityDic["front"]!)
               }.store(in: &cancellables) // 使用 Combine 框架，cancellables 為一個 Cancelable 類型的集合
           }else{
               return
           }
           
       }

    func setUpVideo(toFront useFrontCamera: Bool) {
        // 1. 暫停當前會話
        captureSession.beginConfiguration()
        captureSession.inputs.forEach { input in
            captureSession.removeInput(input)
        }
        captureSession.outputs.forEach { output in
            captureSession.removeOutput(output)
        }

        // 2. 根據新設置選擇相機
        let cameraPosition: AVCaptureDevice.Position = useFrontCamera ? .front : .back
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        previewView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)//modify view size
        
        view.addSubview(previewView)
        // 设置 previewView 的尺寸
        
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video,position: cameraPosition)
        //let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video,position: .front)
        let deviceInput = try! AVCaptureDeviceInput(device: device!)
        
        captureSession.addInput(deviceInput)
        videoOutput = AVCaptureVideoDataOutput()
        
        let queue = DispatchQueue(label: "VideoQueue")
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        captureSession.addOutput(videoOutput)
        if let videoConnection = videoOutput.connection(with: .video) {
            if videoConnection.isVideoOrientationSupported {
                videoConnection.videoOrientation = .portrait
            }
            if(cameraPosition == .front){
                videoConnection.isVideoMirrored = true
            }
        }
        captureSession.commitConfiguration()
        
        //        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //        previewLayer?.frame = previewView.bounds
        //        previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        //        previewView.layer.addSublayer(previewLayer!)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func setupVideo(){
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // 设置 previewView 的尺寸
        previewView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight * 1.0)//modify view size
        
        
        view.addSubview(previewView)
        
        captureSession.beginConfiguration()
        
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video,position: .back)
        //let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video,position: .front)
        let deviceInput = try! AVCaptureDeviceInput(device: device!)
        
        captureSession.addInput(deviceInput)
        videoOutput = AVCaptureVideoDataOutput()
        
        let queue = DispatchQueue(label: "VideoQueue")
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        captureSession.addOutput(videoOutput)
        if let videoConnection = videoOutput.connection(with: .video) {
            if videoConnection.isVideoOrientationSupported {
                videoConnection.videoOrientation = .portrait
            }
            videoConnection.isVideoMirrored = true
        }
        captureSession.commitConfiguration()
        
        //        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //        previewLayer?.frame = previewView.bounds
        //        previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        //        previewView.layer.addSublayer(previewLayer!)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func detection(pixelBuffer: CVPixelBuffer) -> [Detection] {
        let resizedBuffer = resizePixelBuffer(pixelBuffer, width: 256, height: 256)
        guard let buffer = resizedBuffer else { return [] }
        do {
            
            let handler = VNImageRequestHandler(cvPixelBuffer: buffer)
            try handler.perform([modelRequest])
            guard let results = modelRequest.results as? [VNCoreMLFeatureValueObservation] else {
                return []
            }
            var detections:[Detection] = []
            
            for result in results {
                var tmp: [Float]=[]
                if let multiArray = result.featureValue.multiArrayValue {
                    // 遍历 multiArray 并填充 processedArray
                    for i in 0..<51 {
                        tmp.append(Float(multiArray[i]))
                    }
                    var det=(Detection(data: tmp)!)
                    detections.append(det)
                }
            }
            if(!detections.isEmpty){
                return detections
            }
            else{
                DispatchQueue.main.async {
                    self.sharedData.KPS = []
                }
                return []
            }
        } catch let error {
            return []
            print(error)
        }
    }
    
    
    
    
    
    func drawKeypointsLink(kp:[Keypoint],cgContext: CGContext, start:Int,end:Int,color:CGColor,size:CGSize){
        var skeypoint = kp[start]
        var ekeypoint = kp[end]
        if(skeypoint.v<sharedData.KeyPointThreshold || ekeypoint.v<sharedData.KeyPointThreshold){
            return
        }
        
        cgContext.setStrokeColor(color)
        
        //let offset=CGFloat(Int((size.height-size.width)/2))
        let sx = CGFloat(skeypoint.x) * size.width
        let sy = size.height - (CGFloat(skeypoint.y) * size.height)
        let ex = CGFloat(ekeypoint.x) * size.width
        let ey = size.height - (CGFloat(ekeypoint.y) * size.height)
        
        cgContext.addLines(between: [CGPoint(x: sx, y: sy),CGPoint(x: ex, y: ey)])
        cgContext.strokePath()
    }
    
    
    
    func drawRectsOnImage(_ detections: [Detection], _ pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        let size = ciImage.extent.size
        guard let cgContext = CGContext(data: nil,
                                        width: Int(size.width),
                                        height: Int(size.height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * Int(size.width),
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
        for detection in detections {
            //kpline
            cgContext.setLineWidth(3)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:0,end:1,color:UIColor.green.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:1,end:2,color:UIColor.green.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:0,end:2,color:UIColor.green.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:1,end:3,color:UIColor.green.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:2,end:4,color:UIColor.green.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:3,end:5,color:UIColor.green.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:4,end:6,color:UIColor.green.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:5,end:6,color:UIColor.green.cgColor,size:size)
            
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:5,end:11,color:UIColor.orange.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:6,end:12,color:UIColor.purple.cgColor,size:size)
            
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:5,end:7,color:UIColor.blue.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:7,end:9,color:UIColor.blue.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:6,end:8,color:UIColor.blue.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:8,end:10,color:UIColor.blue.cgColor,size:size)
            
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:11,end:12,color:UIColor.red.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:11,end:13,color:UIColor.red.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:13,end:15,color:UIColor.red.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:12,end:14,color:UIColor.red.cgColor,size:size)
            drawKeypointsLink(kp:detection.keypoints,cgContext: cgContext, start:14,end:16,color:UIColor.red.cgColor,size:size)
            //draw point
            
            for (i,keypoint) in detection.keypoints.enumerated(){
                
                if(keypoint.v<sharedData.KeyPointThreshold) {continue}
                let x = CGFloat(keypoint.x) * size.width
                let y = size.height - (CGFloat(keypoint.y) * size.height) // Inverted y because the origin is at the bottom left in Core Graphics
                let pointSize: CGFloat = 10.0 // Size of the point
                
                // Draw a filled circle for each keypoint
                let circleRect = CGRect(x: x - pointSize / 2, y: y - pointSize / 2, width: pointSize, height: pointSize)
                if(i<=4){
                    cgContext.setFillColor(UIColor.green.cgColor)
                }else if(i<=10){
                    cgContext.setFillColor(UIColor.blue.cgColor)
                }else{
                    cgContext.setFillColor(UIColor.red.cgColor)
                }
                cgContext.fillEllipse(in: circleRect)
                
            }
            
        }
        
        guard let newImage = cgContext.makeImage() else { return nil }
        return UIImage(ciImage: CIImage(cgImage: newImage))
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        frameCounter += 1
        if videoSize == CGSize.zero {
            guard let width = sampleBuffer.formatDescription?.dimensions.width,
                  let height = sampleBuffer.formatDescription?.dimensions.height else {
                fatalError()
            }
            videoSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        }
        if frameCounter == frameInterval {
            frameCounter = 0
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            
            //inference result
            var detections = detection(pixelBuffer: pixelBuffer)
            
            //draw
            var drawImage:UIImage?
            if(!detections.isEmpty){
                DispatchQueue.main.async {
                    self.sharedData.KPS = detections[0].keypoints
                }
                drawImage = drawRectsOnImage(detections, pixelBuffer)
            }
            else{
                DispatchQueue.main.async {
                    self.sharedData.KPS = []
                }
                drawImage = UIImage(ciImage:CIImage(cvPixelBuffer: pixelBuffer))
            }
            
            
            //update frame
            DispatchQueue.main.async {
                self.previewView.image = drawImage ?? self.previewView.image
            }
        }
        
    }
}


import SwiftUI

// 定义一个遵循 `UIViewControllerRepresentable` 协议的结构体
struct ViewControllerWrapper: UIViewControllerRepresentable {
    @ObservedObject var sharedData: SharedData
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        viewController.sharedData = sharedData
        return viewController
    }
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}
struct VideoView: View {
    @ObservedObject var sharedData: SharedData
    var body: some View{
        ViewControllerWrapper(sharedData: sharedData)
    }
}
