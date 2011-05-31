class Wish < ActiveRecord::Base
  belongs_to :wisher, :class_name => 'User', :foreign_key => :wisher_id
  belongs_to :activity, :foreign_key => :activity_id
  validates_uniqueness_of :wisher_id, :scope => [:wishee_tw_uid, :activity_id]

  def Wish.wish_a_wish(wisher, wishee_tw_uid, activity)
    old_peer_wish = Wish.find_old_wish(wisher, wishee_tw_uid, activity)
    if old_peer_wish
    then
      old_peer_wish.fulfill(wisher)
    else
      wish = Wish.new
      wish.wisher = wisher
      wish.wishee_tw_uid = wishee_tw_uid.to_s
      wish.activity = activity
      wish.save # it is OK if uniqueness violated
    end
  end

  def Wish.find_old_wish(wisher, wishee_tw_uid, activity)
    cand = User.find_by_provider_and_uid('twitter', wishee_tw_uid.to_s)
    return nil unless cand
    old_wish = Wish.find(:first, :conditions =>
                ["wisher_id = ? AND wishee_tw_uid =? AND activity_id = ?",
                 cand.id, wisher.uid, activity.id])
    return old_wish
  end 

  def fulfill(second)
    first = self.wisher
    act = self.activity.name
    self.destroy
    first.self_dm("@#{second.screen_name}さんもあなたと#{act}たいそうです")
    unless first.id == second.id
      second.self_dm("@#{first.screen_name}さんもあなたと#{act}たいそうです")
    end
  end

  def Wish.recent_wishers(activity)
    a = Wish.all :conditions => ["activity_id = ?", activity.id], :order => "created_at DESC"
    ws = a.collect {|w| w.wisher_id}
    ws = ws.uniq
    ws = ws[0,10] if ws.length > 10
    ws = ws.collect {|w| {:uid => User.find(w).uid, :screen_name => User.find(w).screen_name}}
    return ws
  end
end
