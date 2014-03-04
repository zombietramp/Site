class UsersController < ApplicationController
  
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      #Handle a successful save
      flash[:success] = "Welcome to the Zombie Site!"
      redirect_to  @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
     @user = User.find(params[:id])
     if @user.update_attributes(user_params)
       flash[:success] ="个人信息更新成功！"
       sign_in @user
       redirect_to  @user
     else
       render 'edit'
     end
    
  end
  
  def destroy
    User.find(params[:id]).destroy
    
    flash[:success] ="删除成功！"
    
    redirect_to  users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "请注册用户."
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin
    end
end