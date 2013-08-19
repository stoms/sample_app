class UsersController < ApplicationController

  # rails 4
  #before_action :signed_in_user, only: [:edit, :update]
  # rails 3
  before_filter :signed_in_user, only: [:index, :edit, :update]
  # rails 3
  before_filter :correct_user, only: [:edit, :update]
  before_filter  :admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      flash[:fail] = "Please correct the highlighted errors and try again!"
      render 'new'
    end
  end

  def edit
    # This is performed by the before_filter(rails 3) or
    # before_action(rails4) correct_user method
    #@user = User.find(params[:id])
  end

  def update
    # This is performed by the before_filter(rails 3) or
    # before_action(rails4) correct_user method
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated!"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                                  :password_confirmation)
    end

    # Before actions
    def signed_in_user
      store_location
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
    def admin_user
      @user = User.find(params[:id])
      redirect_to root_url unless @user.admin
    end

end
