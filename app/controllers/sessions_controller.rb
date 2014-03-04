class SessionsController < ApplicationController
  def new
    
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash[:error] ='帐号或密码错误' # Not quite right!
      render 'new'
    end
   
  end
  
  def destory
    sign_out
    redirect_to root_path
    
  end

end
