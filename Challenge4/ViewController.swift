//
//  ViewController.swift
//  Challenge4
//
//  Created by Luca Hummel on 11/08/21.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagens = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tire e salve fotos"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(takePhoto))
        
        let defaults = UserDefaults.standard
        if let savedImages = defaults.object(forKey: "imagens") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                imagens = try jsonDecoder.decode([Image].self, from: savedImages)
            } catch {
                print("Não foi possivel salvar")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Imagem", for: indexPath)
        
        let imagem = imagens[indexPath.row]
        
        cell.textLabel?.text = imagem.caption
        
        let path = getDocumentsDirectory().appendingPathComponent(imagem.imageName)
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController{
            vc.imagem = imagens[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // funcao para abrir camera
    @objc func takePhoto() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let imagem = Image(imageName: imageName, caption: "")
        imagens.append(imagem)
        
        
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Coloque uma legenda", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let Action = UIAlertAction(title: "Salvar", style: .default) {
            [weak self] _ in
            guard let caption = ac.textFields?[0].text else { return }
            print(caption)
            imagem.caption = caption
            self?.save()
            self?.tableView.reloadData()
        }
        ac.addAction(Action)
        present(ac, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let jsonEnconder = JSONEncoder()
        
        if let savedData = try? jsonEnconder.encode(imagens) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "imagens")
        } else {
            print("Não foi possivel salvar")
        }
        
    }
    
    
}

