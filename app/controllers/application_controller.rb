class ApplicationController < ActionController::Base
  #devise利用の機能が使われるとき、その前にconfig_..._tersが実行される
  before_action :configure_permitted_parameters, if: :devise_controller?

  #ログイン後、マイページに移動
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  #protected:呼び出された他のコントローラーからも参照できる
  protected

  #データ操作を許可するアクションメソッドを指定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end

end
