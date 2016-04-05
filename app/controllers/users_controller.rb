class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_profile, :update_profile]
  before_action :check_admin, only: [:index, :new, :edit, :update, :create, :destroy]
  before_action :check_self, only: [:edit_profile, :update_profile]
  #before_action :check_admin_or_self, only: [:show]

  def index
    @users = User.ordering.page(params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def edit_profile
  end

  def update_profile
    if (@user.authenticate(params[:user][:old_password]))
      if @user.update(user_params)
        redirect_to @user, notice: 'Пользователь изменен.'
      else
        render :edit_profile
      end
    else
      #render :action => :edit_profile, :danger => "fsa"
      flash[:danger] = 'Неверный пароль'
      render :edit_profile
    end
  end

  def create
    @user = User.new(user_params)
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
    if @user.update(user_params)
      redirect_to @user, notice: 'Пользователь изменен.'
    else
      render :edit
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
    attrs = [:name, :email, :password, :password_confirmation, :country_id]
    attrs << :role if @current_user.try(:admin?)
    params.require(:user).permit(attrs)
  end

  def check_admin_or_self
    render_error unless User.by_admin?(@current_user) || @user.by_self?(@current_user)
  end

  def check_admin
    render_error unless User.by_admin?(@current_user)
  end

  def check_self
    render_error unless @user.by_self?(@current_user)
  end
end
