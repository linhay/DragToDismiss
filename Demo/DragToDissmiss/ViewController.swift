//
//  ViewController.swift
//  DragToDissmiss
//
//  Created by linhey on 2024/9/4.
//

import UIKit
import DragToDismiss

class ViewController: UIViewController {

    private lazy var button: UIButton = {
        let view = UIButton()
        view.setTitle("tapped", for: .normal)
        view.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        view.backgroundColor = .blue
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
    }
    
    @objc
    func tapped() {
        let vc = PresentedViewController()
        let dragToDismiss = DragToDismissController()
        dragToDismiss.sourceView = button
        dragToDismiss.add(content: vc)
        present(dragToDismiss, animated: true, completion: nil)
    }


}

