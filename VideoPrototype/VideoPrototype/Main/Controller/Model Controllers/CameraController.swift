//
//  CameraController.swift
//  VideoPrototype
//
//  Created by Kenny on 6/3/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import AVFoundation
import UIKit

protocol PresentCameraUIDelegate: UIViewController {
    func showCamera()
}

protocol CameraUIDelegate: AVCaptureFileOutputRecordingDelegate, UIViewController {
    func playMovie(url: URL)
    var cameraView: CameraPreviewView! { get set }
}

class CameraController {
    // MARK: - Properties -
    weak var presentationDelegate: PresentCameraUIDelegate?
    weak var cameraDelegate: CameraUIDelegate?
    lazy var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var player: AVPlayer?

    // MARK: - Permission -
    func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            presentationDelegate?.showCamera()
        case .denied:
            // FIXME: Open settings app
            fatalError("Show user UI to get them to give access")
        case .notDetermined:
            requestCameraPermission()
        case .restricted:
            // Parental Controls,
            // FIXME: alert your parental controls have restricted your use of the camera
            // FIXME: Open Settings with Alert.showWithYesNoPrompt
            fatalError("Show user alert for parental controls")
        @unknown default:
            fatalError("Apple added another enum value that we're not handling")
        }
    }

    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            guard granted else { fatalError("access denied") }
            DispatchQueue.main.async {
                self.presentationDelegate?.showCamera()
            }
        }
    }

    private func setupCaptureSession() {
        //Camera
        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
            cameraDelegate?.cameraView.session = captureSession
        }
        let camera = bestCamera()

        guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(cameraInput)
        else { fatalError("Cannot create camera input, do something better than crashing?") }
        captureSession.addInput(cameraInput)
        // Quality
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }

        //Outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot add movie recording. File error")
        }
        captureSession.addOutput(fileOutput)
    }

    private func bestCamera() -> AVCaptureDevice {
        if let ultraWideCamera = AVCaptureDevice.default(
            .builtInUltraWideCamera,
            for: .video,
            position: .back
            ) {
            return ultraWideCamera
        }
        if let wideAngleCamera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
            ) {
            return wideAngleCamera
        }
        fatalError("This operation requires a camera!")
    }

    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }

}
