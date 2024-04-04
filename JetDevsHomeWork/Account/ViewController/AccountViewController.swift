//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class AccountViewController: UIViewController {
    
    @IBOutlet weak var nonLoginView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    
    private var viewModel: AccountViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        nonLoginView.isHidden = false
        loginView.isHidden = true
        setupBindings()
    }
    
    // MARK: -
    
    private func setupBindings() {
        viewModel.userModel
            .asObservable()
            .bind { [weak self] user in
                self?.updateUserProfile(user)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateUserProfile(_ user: UserModel?) {
        nonLoginView.isHidden = user != nil
        loginView.isHidden = user == nil
        guard let user = user else {
            return
        }
        headImageView.kf.setImage(with: user.profileURL, placeholder: UIImage(named: "avatar"))
        nameLabel.text = user.name
        daysLabel.text = "Created \(user.createdAt.daysSince) days ago"
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonTap(_ sender: UIButton) {
        let loginViewController = LoginViewController.instantiateFromXib()
        self.present(loginViewController, animated: true) {
        }
    }
}

extension AccountViewController {
    
    static func instantiateFromXib() -> AccountViewController {
        let controller = AccountViewController.instantiateFromXib(nibName: String(describing: AccountViewController.self))
        controller.viewModel = AccountViewModel.initDependencies()
        return controller
    }
}
