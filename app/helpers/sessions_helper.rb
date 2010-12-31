module SessionsHelper
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end
  
  def current_user=(user) #setter method
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token # @current_user = @current_user || user_from_remember_token
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    current_user = nil
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def authenticate
     deny_access unless signed_in?
  end
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def store_location
    session[:return_to] = request.fullpath # store the full request path in the current session cookie
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default) # redir to path saved above, or to passed default if nil
    clear_return_to
  end
  
  def clear_return_to
    session[:return_to] = nil
  end
  
  private
  def user_from_remember_token
    User.authenticate_with_salt(*remember_token) # *[x, y] = x, y - * 'unwraps' content in array 
    
  end
  
  def remember_token
    cookies.signed[:remember_token] || [nil, nil] # 
  end
  
end
