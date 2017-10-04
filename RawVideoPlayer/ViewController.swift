//
//  ViewController.swift
//  RawVideoPlayer
//
//  Created by Alsey Coleman Miller on 8/31/17.
//  Copyright © 2017 Coleman. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import VLCKitSwift

final class ViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet private(set) weak var playerView: UIView!
    
    @IBOutlet fileprivate(set) weak var playBarButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    
    fileprivate lazy var mediaPlayer: Player = Player()

    // MARK: - Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // configure media player
        //mediaPlayer.delegate = self
        mediaPlayer.drawable = .view(playerView)
        
        // show toolbar
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func open(_ sender: AnyObject? = nil) {
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMPEG4 as String], in: .import)
        documentPicker.delegate = self
        
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func openURL(_ sender: AnyObject? = nil) {
        
        let alert = UIAlertController(title: "Open URL",
                                      message: "Type the URL of the video you want to play",
                                      preferredStyle: .alert)
        
        var textField: UITextField!
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Open", style: .default, handler: { [weak self] _ in
            
            alert.dismiss(animated: true) { }
            
            let text = textField.text ?? ""
            print("Will play \(text)")
            guard let url = URL(string: text) else { return }
            self?.mediaPlayer.media = Media(url: url)
            self?.mediaPlayer.play()
        }))
        
        alert.addTextField {
            textField = $0
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func play(_ sender: AnyObject? = nil) {
        
        let oldState = mediaPlayer.isPlaying
        
        let shouldPlay = oldState == false
        
        if shouldPlay {
            /*
            if mediaPlayer.state == .stopped {
                
                // reset player
                mediaPlayer.media = VLCMedia(url: mediaPlayer.media.url)
            }*/
            
            mediaPlayer.play()
            
        } else {
            
            mediaPlayer.pause()
        }
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        
        let playItem: UIBarButtonSystemItem = mediaPlayer.isPlaying ? .pause : .play
        
        playBarButtonItem = UIBarButtonItem(barButtonSystemItem: playItem, target: self, action: #selector(play))
    }
}

// MARK: - Protocols
/*
extension ViewController: VLCMediaPlayerDelegate {
    
    @objc
    internal func mediaPlayerStateChanged(_ aNotification: Notification!) {
        
        switch mediaPlayer.state {
            
        case .ended:
            
            playBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(play))
            
        case .playing, .opening:
            
            playBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(play))
            
        case .paused:
            
            playBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(play))
            
        default: break
        }
    }
}
*/
extension ViewController: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        mediaPlayer.media = Media(url: url)
        mediaPlayer.play()
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
