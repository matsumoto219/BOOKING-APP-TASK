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

    if @user.update(account_params)
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
    params.require(:user).permit(:name, :introduction, :image_name)
  end
end
