class SessionController < ApplicationController
  def callback
    auth = request.env["omniauth.auth"]
    user = User.find_existing(auth)
    unless user
      user = User.create_with_omniauth(auth)
      user.self_dm("相手と気があったらこのように通知されます")
      session[:notice] = "Twitterのメッセージ例を送りました"
    end
    session[:user_id] = user.id
    if session[:activity_id]
      redirect_to :controller => 'nani', :action => 'wish', :activity_id => session[:activity_id], :wishee_screen_name => session[:wishee_screen_name]
      return
    end
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    session.clear
    redirect_to :back, :notice => "Signed out!"
  end
end
