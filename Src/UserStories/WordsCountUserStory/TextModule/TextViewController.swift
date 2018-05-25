//
//  TextViewController.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    //MARK: - Properties
    var text: String?
    @IBOutlet weak var textView: UITextView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        textView.isScrollEnabled = true
    }
    
    //MARK: - Private Methods
    fileprivate func setupTextView() {
        textView.isScrollEnabled = false
        textView.text = text
        textView.textContainerInset.left = 16
        textView.textContainerInset.right = 16
    }

}
