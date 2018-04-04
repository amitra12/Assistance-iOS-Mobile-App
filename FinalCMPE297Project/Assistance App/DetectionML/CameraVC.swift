//  Created by Aparajita Mitra on 01/12/17.
//  Copyright © 2017 Aparajita. All rights reserved.


import UIKit
import AVFoundation //Configure interactions from media
import CoreML
import Vision //image analysis

enum FlashState {
    case off
    case on
}

class CameraVC: UIViewController
{
    
    var captureSession: AVCaptureSession! //Manages capture activity
    var cameraOutput: AVCapturePhotoOutput! //capture output
    var previewLayer: AVCaptureVideoPreviewLayer! //displays video
    
    var photoData: Data? //image captured is sent to image view
    
    var flashControlState: FlashState = .off
    
    var speechSynthesizer = AVSpeechSynthesizer() //produces synthesized speech from text

    var identification : String = String()
    var identification_1 : String = String()
    var confidence: Int = Int();
    var confidence_1: Int = Int();
    var completeSentence : String = String()
    var errorString : String = String()

    

    @IBOutlet weak var cameraVIew: UIView!
    @IBOutlet weak var captureImageView: RoundedShadowImageView!

    @IBOutlet weak var confidenceLbl: UILabel!
    @IBOutlet weak var identificationLbl: UILabel!
    @IBOutlet weak var flashBtn: RoundedShadowButton!
    
    @IBOutlet weak var Back: UIButton!
    @IBOutlet weak var roundedLblView: RoundedShadowView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad() //view of the corresponding view controller is loaded
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) //A Boolean value indicating whether the transition should be animated.
        previewLayer.frame = cameraVIew.bounds //Intialize the camera view within the bounded frame
        speechSynthesizer.delegate = self //delegate object that receives speech synthesis events
        spinner.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView))
        tap.numberOfTapsRequired = 1

        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080

        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)

        do {
            let input = try AVCaptureDeviceInput(device: backCamera!)
            if captureSession.canAddInput(input) == true {
                captureSession.addInput(input)
            }

            cameraOutput = AVCapturePhotoOutput()

            if captureSession.canAddOutput(cameraOutput) == true {
                captureSession.addOutput(cameraOutput!)

                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait

                cameraVIew.layer.addSublayer(previewLayer!)
                cameraVIew.addGestureRecognizer(tap)
                captureSession.startRunning()
            }
        } catch {
            debugPrint(error)
        }
    }

    @objc func didTapCameraView() {
        self.cameraVIew.isUserInteractionEnabled = false
        self.spinner.isHidden = false
        self.spinner.startAnimating()

        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.__availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType, kCVPixelBufferWidthKey as String: 160, kCVPixelBufferHeightKey as String: 160]

        settings.isAutoStillImageStabilizationEnabled = true
        self.cameraOutput.photoSettingsForSceneMonitoring = settings

        settings.previewPhotoFormat = previewFormat

        if flashControlState == .off {
            settings.flashMode = .off
        } else {
            settings.flashMode = .on
        }

        cameraOutput.capturePhoto(with: settings, delegate: self)
    }

    func resultsMethod(request: VNRequest, error: Error?)
    {
        guard let results = request.results as? [VNClassificationObservation] else { return }

        for classification in results
        {
            if classification.confidence < 0.2 {


                identification = classification.identifier
                confidence = Int(classification.confidence * 100)

                errorString = "Confidence is low around \(confidence) percent. Unable to detect using Squeeze Net Model "
                // self.identificationLbl.text = classification.identifier
                synthesizeSpeech(fromString: errorString)
                // self.confidenceLbl.text = "CONFIDENCE : \(classification.confidence)%"

                break;

            } else {
                print("Hello SqueezeNet");
                identification = classification.identifier
                confidence = Int(classification.confidence * 100)

                print("identification",identification,"confidence:",confidence);
                completeSentence = "Object detected using Squeeze Net model is \(identification) and confidence is \(confidence) percent."
                synthesizeSpeech(fromString: completeSentence)

                break;
            }
        }
    }

   func resultsMethod1(request: VNRequest, error: Error?)
    {
        guard let results1 = request.results as? [VNClassificationObservation] else { return }


        for classification1 in results1
        {
            print("classification.confidence",classification1.confidence);
            if classification1.confidence < 0.2 {

                //self.identificationLbl.text = classification1.identifier
//                synthesizeSpeech(fromString: unknownObjectMessage)

                //self.confidenceLbl.text = ""


                identification_1 = classification1.identifier
                confidence_1 = Int(classification1.confidence * 100)
                errorString = "Confidence is low around \(confidence_1) percent.Unable to detect using Inceptionv3 Model "
                synthesizeSpeech(fromString: errorString)

            }
            if classification1.confidence > 0.2{
                print("Hello Inceptionv3");
                identification_1 = classification1.identifier
                confidence_1 = Int(classification1.confidence * 100)

                print("identification",identification_1,"confidence:",confidence_1);
                let completeSentence1 = "Object detected using Inceptionv3 Model is \(identification_1) and confidence is  \(confidence_1) percent."
                synthesizeSpeech(fromString: completeSentence1)

            }
            if(confidence_1 > confidence){
                print("Hello IF");
                self.identificationLbl.text = identification_1
                self.confidenceLbl.text = "CONFIDENCE : \(confidence_1)%"
                let resultSentence1 = "Correct object is \(identification_1) with confidence is  \(confidence_1) percent. This is using Inception V3 Model. Solution is based on higher object confidence "
                synthesizeSpeech(fromString: resultSentence1)
                confidence_1 = 0;
                identification_1 = "";
                break;
            }
            else {
                print("Hello ELSE");
                self.identificationLbl.text = identification
                self.confidenceLbl.text = "CONFIDENCE : \(confidence)%"
                let anotherSentence = "Correct object is \(identification) with confidence is  \(confidence) percent. This is using Squeeze Net Model . Solution is based on higher object confidence "
                synthesizeSpeech(fromString: anotherSentence)
                confidence = 0;
                identification = "";
                break;
            }
        }
    }

    func synthesizeSpeech(fromString string: String) {
        let speechUtterance = AVSpeechUtterance(string: string)
        speechSynthesizer.speak(speechUtterance)
    }

    @IBAction func flashBtnWasPressed(_ sender: Any) {
        switch flashControlState {
        case .off:
            flashBtn.setTitle("FLASH ON", for: .normal)
            flashControlState = .on
        case .on:
            flashBtn.setTitle("FLASH OFF", for: .normal)
            flashControlState = .off
        }
    }

}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint(error)
        } else {
            photoData = photo.fileDataRepresentation()

            let handler = VNImageRequestHandler(data: photoData!)
            let handler_1 = VNImageRequestHandler(data: photoData!)
            do {






                let model = try VNCoreMLModel(for: SqueezeNet().model)
                let request = VNCoreMLRequest(model: model, completionHandler: resultsMethod)


                let model_1 = try VNCoreMLModel(for: Inceptionv3().model)
                let request_1 = VNCoreMLRequest(model: model_1, completionHandler: resultsMethod1)

                try handler.perform([request])
                //debugprint("This is SqueezeNet")



                try handler_1.perform([request_1])
                //debugprint("This is Inception")

            }
            catch
            {
                debugPrint(error)
            }

//            do {
//                let model = try VNCoreMLModel(for: SqueezeNet().model)
//                let request = VNCoreMLRequest(model: model, completionHandler: resultsMethod)
//                let handler = VNImageRequestHandler(data: photoData!)
//                try handler.perform([request])
//                //debugprint("This is SqueezeNet")
//
//
//            }
//            catch
//            {
//                debugPrint(error)
//            }



            let image = UIImage(data: photoData!)
            self.captureImageView.image = image
        }
    }
}

extension CameraVC: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.cameraVIew.isUserInteractionEnabled = true
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
    }



}











