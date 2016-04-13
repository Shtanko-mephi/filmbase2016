class UsersController < ApplicationController
  before_action :check_authentication, only: [:edit, :update, :destroy]
  before_action :check_banned, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:destroy]
  before_action :check_admin_or_self, only: [:show, :edit, :update]

  def index
    respond_to do |format|
      format.html{@users = User.ordering.page(params[:page])}
      format.json{@users = User.search(params[:q]).all}
    end
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
      @user = User.new(user_params_pass)
    if @user.save
      if @current_user
        redirect_to @user, notice: 'Пользователь создан'
      else
        authenticate_user(@user)
        redirect_to root_path, notice: 'Регистрация завершена'
      end
    else
      render :new
    end
  end

  def update
    if (@user == @current_user)
      if (@user.authenticate(params[:user][:old_password]))
        if @user.update(user_params)
          redirect_to @user, notice: 'Пользователь изменен.'
        else
          render :edit
        end
      else
        flash.now[:danger] = 'Неверный пароль'
        render :edit
      end
    elsif @current_user.try(:admin?)
      if @user.update(user_params)
        redirect_to @user, notice: 'Пользователь изменен.'
      else
        render :edit
      end
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'Пользователь удален'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    attrs = [:name, :email, :country_id, :info, :birthday, :avatar]
    if @user == @current_user
      attrs += [:password, :password_confirmation]
    elsif @current_user.try(:admin?)
      attrs += [:role, :banned]
    end
    params.require(:user).permit(attrs)
  end

  def user_params_pass
    attrs = [:name, :email, :country_id, :info, :birthday, :avatar, :password, :password_confirmation]
    if @current_user.try(:admin?)
      attrs += [:role, :banned]
    end
    params.require(:user).permit(attrs)
  end

  def check_admin_or_self
    render_error unless User.by_admin?(@current_user) || @user.by_self?(@current_user)
  end

  def check_admin
    render_error unless User.by_admin?(@current_user) && @user != @current_user
  end

  def check_self
    render_error unless @user.by_self?(@current_user)
  end
end
