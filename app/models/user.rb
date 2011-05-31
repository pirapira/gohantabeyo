class User < ActiveRecord::Base

  validates_uniqueness_of :uid, :scope => :provider
  def self.create_with_omniauth(auth)
    create! do |user|
      user.set_by(auth)
    end
  end
  def self.find_existing(auth)
    ret = User.find_by_provider_and_uid(auth["provider"], auth["uid"])
    if ret
      ret.set_by(auth)
      ret.save!
    end
    return ret
  end
  def set_by(auth)
   self.provider = auth["provider"]
   self.uid = auth["uid"]
   self.name = auth["user_info"]["name"]
   self.screen_name = auth["user_info"]["nickname"]
   self.token = auth['credentials']['token']
   self.secret = auth['credentials']['secret']
  end
  def post(message)
    client.update(message) rescue nil
  end
  def self_dm(message)
    message = message + " http://gohantabeyo.com"
    client.direct_message_create(self.uid.to_i, message) rescue nil
  end
  def client
    return Twitter::Client.new(:oauth_token => self.token,
               :oauth_token_secret => self.secret)
  end
end
