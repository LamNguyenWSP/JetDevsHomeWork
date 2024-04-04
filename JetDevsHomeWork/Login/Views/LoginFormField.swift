//
//  LoginFormField.swift
//  JetDevsHomeWork
//
//  Created by Lâm Nguyễn on 04/04/2024.
//

import UIKit

@IBDesignable
class LoginFormField: UIView {
    @IBInspectable var title: String = ""
    
    private let roundedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.disabled.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let labelBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.text
        label.textAlignment = .center
        label.font = UIFont.latoRegularFont(size: 12)
        label.backgroundColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.text = title
    }
    
    private func setupViews() {
        insertSubview(roundedView, at: 0)
        insertSubview(labelBackgroundView, aboveSubview: roundedView)
        labelBackgroundView.addSubview(label)
        
        NSLayoutConstraint.activate([
            roundedView.topAnchor.constraint(equalTo: topAnchor),
            roundedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            roundedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            roundedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelBackgroundView.topAnchor.constraint(equalTo: roundedView.topAnchor, constant: -10),
            labelBackgroundView.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor, constant: 14),
            label.topAnchor.constraint(equalTo: labelBackgroundView.topAnchor, constant: 2),
            label.leadingAnchor.constraint(equalTo: labelBackgroundView.leadingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: labelBackgroundView.trailingAnchor, constant: -6),
            label.bottomAnchor.constraint(equalTo: labelBackgroundView.bottomAnchor, constant: 2)
        ])
    }
}
