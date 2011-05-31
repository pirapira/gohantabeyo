class Adv < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :activity, :foreign_key => :activity_id
  validates_uniqueness_of :user_id, :scope => [:activity_id]

  def Adv.make(user, activity)
    already = Adv.find(:first, :conditions =>
                ["user_id = ? AND activity_id = ?", user.id, activity.id])
    return if already

    user.post("#{activity.name}たい誰かを登録しました。 http://gohantabeyo.com/nani/#{activity.id}")
    user.self_dm("タイムラインに投稿しました。同内容の投稿は一回限りの予定です。")

    record = Adv.new
    record.user = user
    record.activity = activity
    record.save
  end
end
