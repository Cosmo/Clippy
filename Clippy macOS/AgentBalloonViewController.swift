//
//  AgentBalloonViewController.swift
//  Clippy macOS
//
//  Created by Devran on 09.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Cocoa

class BalloonViewController: NSViewController {
    let stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.alignment = .leading
        stackView.edgeInsets = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return stackView
    }()
    
    let titleLabel: NSTextField = {
        let textField = NSTextField(wrappingLabelWithString: "It looks like you're writing a letter")
        textField.font = .boldSystemFont(ofSize: NSFont.systemFontSize)
        textField.textColor = NSColor.labelColor
        return textField
    }()
    
    let descriptionLabel: NSTextField = {
        let textField = NSTextField(wrappingLabelWithString: "Would you like help?")
        textField.font = .systemFont(ofSize: NSFont.systemFontSize)
        textField.textColor = NSColor.labelColor
        return textField
    }()
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(titleValue: String, descriptionValue: String) {
        self.init(nibName: nil, bundle: nil)
        titleLabel.stringValue = titleValue
        descriptionLabel.stringValue = descriptionValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 300, height: 500)))
        view.wantsLayer = true
        view.layer?.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
    }
}
