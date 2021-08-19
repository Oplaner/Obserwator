import CoreImage
import Vision

// Default saturation: 1.
func desaturation(forImage image: CIImage) -> CIImage {
    CIFilter(name: "CIColorControls", parameters: [kCIInputImageKey: image, kCIInputSaturationKey: 0])!.outputImage!
}

// Default exposure: 0.5.
func exposureAdjustment(forImage image: CIImage) -> CIImage {
    CIFilter(name: "CIExposureAdjust", parameters: [kCIInputImageKey: image, kCIInputEVKey: 2])!.outputImage!
}

// Default brightness: 0.
// Default contrast: 1.
func colorAdjustment(forImage image: CIImage) -> CIImage {
    CIFilter(name: "CIColorControls", parameters: [kCIInputImageKey: image, kCIInputBrightnessKey: 0.45, kCIInputContrastKey: 2])!.outputImage!
}

// Default highlight amount: 1.
func highlightAdjustment(forImage image: CIImage) -> CIImage {
    CIFilter(name: "CIHighlightShadowAdjust", parameters: [kCIInputImageKey: image, "inputHighlightAmount": 0])!.outputImage!
}

// Default radius: 10.
func blur(forImage image: CIImage) -> CIImage {
    CIFilter(name: "CIBoxBlur", parameters: [kCIInputImageKey: image, kCIInputRadiusKey: 4])!.outputImage!
}

let context = CIContext()
let imageNumber = 9
let image = CIImage(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: String(imageNumber), ofType: "png")!))!

var imageCorrected = image
imageCorrected = desaturation(forImage: imageCorrected)
imageCorrected = exposureAdjustment(forImage: imageCorrected)
imageCorrected = highlightAdjustment(forImage: imageCorrected)
imageCorrected = colorAdjustment(forImage: imageCorrected)
imageCorrected = highlightAdjustment(forImage: imageCorrected)
imageCorrected = blur(forImage: imageCorrected)

context.clearCaches()

let request = VNRecognizeTextRequest() { (request, _) in
    let results = request.results as? [VNRecognizedTextObservation]
    let topCandidate = results?.first?.topCandidates(1).first
    print(topCandidate?.string as Any)
    print(topCandidate?.confidence as Any)
}
request.customWords = ["5", "10", "15", "20", "25", "30", "40", "50", "60", "70", "80", "90", "100", "110", "120", "130"]
request.minimumTextHeight = 0.1
request.recognitionLevel = .fast
request.revision = VNRecognizeTextRequestRevision1
request.usesLanguageCorrection = true

for (index, image) in [0: image, 1: imageCorrected] {
    let handler = VNImageRequestHandler(ciImage: image, options: [:])

    do {
        switch index {
        case 0:
            print("\nImage:")
        case 1:
            print("\nImage corrected:")
        default:
            print()
        }
        
        try handler.perform([request])
    } catch {
        print(error.localizedDescription)
    }
}
