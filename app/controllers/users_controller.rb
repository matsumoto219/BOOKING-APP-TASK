class UsersController < ApplicationController
  before_action :authenticate_user!

  # READ
  def show
    @user = current_user
  end

  # UPDATE
  def edit_account
    @user = current_user
  end

  # UPDATE
  def update_account
    @user = current_user

    # パスワードチェック
    params_to_update = account_params
    if params_to_update[:password].blank? && params_to_update[:password_confirmation].blank?
      params_to_update = params_to_update.except(:password, :password_confirmation)
    end

    if @user.update(params_to_update)
      redirect_to user_path, notice: "アカウント情報を更新しました"
    else
      render :edit_account, status: :unprocessable_entity
    end
  end

  # UPDATE
  def edit_profile
    @user = current_user
  end

  # UPDATE
  def update_profile
    @user = current_user

    if @user.update(profile_params)
      redirect_to user_path, notice: "プロフィールを更新しました"
    else
      render :edit_profile, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def profile_params
    params.require(:user).permit(:name, :introduction, :image)
  end
end
