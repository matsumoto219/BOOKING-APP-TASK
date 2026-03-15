class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # ユーザー登録やアカウント更新時に追加カラムをパラメータとして許可するためのメソッドを呼び出す
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # 追加したカラム(name, introduction, image_name)を保存できるように許可する
  def configure_permitted_parameters
    # 新規登録(sign_up)時に許可する項目
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :introduction, :image_name ])

    # アカウント編集(account_update)時に許可する項目
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :introduction, :image_name ])
  end
end
