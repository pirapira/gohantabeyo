class NaniController < ApplicationController

  def show
    @activity = Activity.find(params[:activity_id])
    @recent_wishers = Wish.recent_wishers(@activity)
  end

  def create
    name = params[:activity_name]
    @activity = Activity.find_or_create(name)
    redirect_to :action => 'show', :activity_id => @activity.id
  end

  def wish
    unless session[:user_id]
      session[:activity_id] = params[:activity_id]
      session[:wishee_screen_name] = params[:wishee_screen_name]
      redirect_to "/auth/twitter"
      return
    end

    wisher = User.find(session[:user_id])
    client = wisher.client

    # lookup peer uid
    activity_id = params[:activity_id]
    activity = Activity.find(activity_id)
    wishee_screen_name = params[:wishee_screen_name]

    if u = client.user(wishee_screen_name)
      wishee_uid = u[:id]
    end

    # make a wish
    Wish.wish_a_wish(wisher,wishee_uid,activity) 
    Adv.make(wisher,activity)

    session[:activity_id] = nil
    session[:wishee_screen_name] = nil

    session[:notice] = "@#{wishee_screen_name}も#{activity.name}たいとわかったらtwitterのメッセージでお知らせします"
    redirect_to :action => "show", :activity_id => activity.id
  end
end
