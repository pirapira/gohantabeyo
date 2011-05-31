class HomeController < ApplicationController
  def index
    @activity = Activity.find_or_create("ごはんたべ")
    redirect_to :controller => 'nani', :action => 'show', :activity_id => @activity.id
  end

end
