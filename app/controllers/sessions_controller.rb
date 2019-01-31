class SessionsController <ApplicationController

  #if oauth is present, login via oauth
  def create
    if auth.present?
        @user = User.from_omniauth(request.env["omniauth.auth"])
        session[:user_id] = @user.id
        redirect_to user_path(@user), notice: "You are logged in"
      end
    #if oauth is not present, find and validate user by name and password and go to users show 
    if params[:name].present?
      @user = User.find_by_name(params[:name])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect_to user_path(@user), notice: "You are logged in"
      else
       if @user
        flash[:alert] = "Please check your credentials"
      else 
        flash[:alert] = "Please check your credentials"
      end
      render 'new'
    end
  end
end

  #auth method requesting credentials for google auth credentials
  def auth
    request.env['omniauth.auth']
  end

   def destroy
    session.destroy
    redirect_to '/', notice: "You are logged out"
  end

end