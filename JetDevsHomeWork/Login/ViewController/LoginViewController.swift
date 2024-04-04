//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by Lâm Nguyễn on 04/04/2024.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func configUI() {
    }
    
    private func setupBindings() {
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.isLoginEnabled.bind { [weak self] isEnabled in
            self?.updateLoginButtonEnabled(isEnabled)
        }
        .disposed(by: disposeBag)
        loginButton.rx.tap
            .bind(to: viewModel.loginButtonTapped)
            .disposed(by: disposeBag)
        
        bindingAuthSuccess()
        bindingLoadingIndicator()
        bindingAuthErrorAlert()
    }
    
    private func bindingAuthSuccess() {
        viewModel.userModel
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindingLoadingIndicator() {
        viewModel.isLoading
            .subscribe(onNext: { isLoading in
                isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindingAuthErrorAlert() {
        viewModel.errorMessage
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] message in
                self?.showErrorAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: -
    
    private func updateLoginButtonEnabled(_ isEnabled: Bool) {
        loginButton.isEnabled = isEnabled
        loginButton.backgroundColor = isEnabled ? UIColor.main : UIColor.disabled
        loginButton.layer.cornerRadius = 6.0
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = UIFont.latoRegularFont(size: 18.0)
        loginButton.tintColor = UIColor.white
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .disabled)
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Close", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func dismiss() {
        dismiss(animated: true)
    }
    
    // MARK: - Action
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss()
    }
}

extension LoginViewController {
    
    static func instantiateFromXib() -> LoginViewController {
        let controller = LoginViewController.instantiateFromXib(nibName: String(describing: LoginViewController.self))
        controller.viewModel = LoginViewModel.initDependencies()
        return controller
    }
}
