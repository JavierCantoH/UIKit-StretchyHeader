//
//  CustomHeaderView.swift
//  StretchyHeader_Final
//
//  Created by Luis Javier Canto Hurtado on 13/07/22.
//

import UIKit
class CustomHeaderView: UIView {
    
    var backgroundImageName: String
    var titleLabelText: String
    var headerIconName: String
    var bgBackgroundColor: UIColor
    
    init(frame: CGRect, backgroundImage: String, title: String, iconImage: String, bgBackgroundColor: UIColor) {
        self.backgroundImageName = backgroundImage
        self.titleLabelText = title
        self.headerIconName = iconImage
        self.bgBackgroundColor = bgBackgroundColor
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: backgroundImageName)
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleLabelText.uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var headerIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: headerIconName)
        return image
    }()
    
    private lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.backgroundColor = bgBackgroundColor
        colorView.alpha = 0.6
        return colorView
    }()
    
    private func setUpView() {
        backgroundColor = UIColor.white
        addSubview(backgroundImage)
        addSubview(colorView)
        addSubview(titleLabel)
        addSubview(headerIcon)
        constraintsSetUp()
    }
    
    private func constraintsSetUp() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            colorView.topAnchor.constraint(equalTo: topAnchor),
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            headerIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 6),
            headerIcon.widthAnchor.constraint(equalToConstant: 40),
            headerIcon.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func decrementColorAlpha(offset: CGFloat) {
        if colorView.alpha <= 1 {
            let alphaOffset = (offset/500)/85
            colorView.alpha += alphaOffset
        }
    }
    
    func decrementHeaderIconAlpha(offset: CGFloat) {
        if headerIcon.alpha >= 0 {
            let alphaOffset = max((offset - 65)/85.0, 0)
            headerIcon.alpha = alphaOffset
        }
    }
    
    func incrementColorAlpha(offset: CGFloat) {
        if colorView.alpha >= 0.6 {
            let alphaOffset = (offset/200)/85
            colorView.alpha -= alphaOffset
        }
    }
    
    func incrementHeaderIconAlpha(offset: CGFloat) {
        if headerIcon.alpha <= 1 {
            let alphaOffset = max((offset - 65)/85, 0)
            headerIcon.alpha = alphaOffset
        }
    }
}
