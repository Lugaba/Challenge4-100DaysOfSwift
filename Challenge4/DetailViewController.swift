//
//  DetailViewController.swift
//  Challenge4
//
//  Created by Luca Hummel on 11/08/21.
//

import UIKit

class DetailViewController: UIViewController {
    var imagem: Image!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = imagem.caption
        navigationItem.largeTitleDisplayMode = .never
        
        let path = getDocumentsDirectory().appendingPathComponent(imagem.imageName)
        imageView.image = UIImage(contentsOfFile: path.path)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
