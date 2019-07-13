//
//  ViewController.swift
//  CameraFilter
//
//  Created by Naoki Muroya on 2019/06/23.
//  Copyright © 2019 Naoki Muroya. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        applyButton.isHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nVC = segue.destination as? UINavigationController,
            let photosCVC = nVC.viewControllers.first as? PhotosCollectionViewController else { fatalError("segue.destination is not found") }
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            self?.updateUI(with: photo)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        guard let sourceImage = photoImageView.image else { fatalError("sourceimage is nil") }
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
    }

    private func updateUI(with image: UIImage) {
        photoImageView.image = image
        applyButton.isHidden = false
    }
}

