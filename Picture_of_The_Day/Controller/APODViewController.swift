//
//  APODViewController.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 12/06/22.
//


import UIKit

class APODViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var explanationTextview: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteListButton: UIButton!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var playButton: UIButton!

    var picture: Picture!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = Date()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetworkMonitor.shared.startMonitoring()
        if let picture = self.picture {
            self.favoriteButton.handleFavoriteState(picture: picture)
        } else {
            perform(#selector(loadPicture), with:datePicker.date.yearMonthDateString(), afterDelay: 0.5)
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NetworkMonitor.shared.stopMonitoring()
    }
    
    
    
    @objc func loadPicture(date:String) {
        if NetworkMonitor.shared.isReachable {
            handleUIElementsState(enabled: true)
            self.activityIndicator.startAnimating()
            PictureRequest.searchForPicture(date: date) {[unowned self] picture in
                if let picture = picture {
                    self.picture = picture
                    prepareForMediatype(picture: picture)
                    updatePictureInformation(picture: picture)
                    self.imageView.downloadImage(picture: picture,isHD: false) {
                        self.activityIndicator.stopAnimating()
                        self.favoriteButton.handleFavoriteState(picture: picture)
                        self.container.isHidden = false
                    }
                } else {
                    handleUIElementsState(enabled: true)
                    AlertService.showOKAlert(title: "Something went wrong!", message: "Unable to fetch picture data! Try Serching with different date", viewController: self)
                }
                
            }
        } else {
            handleUIElementsState(enabled: false)
            let picture = PictureDataManager.shared.getLastSavedPicture()
            if let picture = picture {
                updatePictureInformation(picture: picture)
                if let image = picture.image {
                    imageView.image = UIImage(data: image)
                }
                self.container.isHidden = false
                AlertService.showOKAlert(title:"No Internet Connection!", message: "Valid information might not be avaialble!", viewController: self)
            } else {
                AlertService.showOKAlert(title: "No Internet Connection!", message: "Please connect to the internet and try again!", viewController: self)
            }
        }
        
    }
    
    
    func updatePictureInformation(picture: Picture) {
        self.titleLabel.text = picture.title ?? ""
        self.dateLabel.text = picture.date ?? ""
        self.explanationTextview.text = picture.explanation ?? ""
        
    }
    
    
    func handleUIElementsState(enabled:Bool) {
        self.datePicker.isEnabled = enabled
        self.favoriteListButton.isEnabled = enabled
    }
    
    func prepareForMediatype(picture:Picture) {
        if let mediatype = picture.media_type {
            switch MediaType(rawValue:mediatype) {
            case .image:
                self.fullScreenButton.isHidden = false
                self.playButton.isHidden = true
                break
            case .video:
                self.fullScreenButton.isHidden = true
                self.playButton.isHidden = false
                break
            default:
                break
            }
        }
       
    }
    
    @IBAction func dateSelected() {
        self.container.isHidden = true
        self.dismiss(animated: false, completion: nil)
        loadPicture(date: datePicker.date.yearMonthDateString())
    }
    
    @IBAction func markfavorite() {
        if  let updatedPicture = PictureDataManager.shared.getPictureWithUrl(url: picture.url!) {
            let favorite = updatedPicture.favorite ?? false
            PictureDataManager.shared.updateFavoriteState(picture: picture, isFavorite:  !favorite)
            self.favoriteButton.handleFavoriteState(picture: picture)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Identifier.PicturePreviewControllerId {
            let viewController = segue.destination as? PicturePreviewController
            viewController?.picture = picture
        } else if segue.identifier == Constants.Identifier.VideoPreviewControllerId {
            let viewController = segue.destination as? VideoPreviewController
            viewController?.previewUrlString = picture.url
        }
    }
}

