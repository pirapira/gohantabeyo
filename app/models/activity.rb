class Activity < ActiveRecord::Base
  validates_uniqueness_of :name

  def Activity.find_or_create(name)
    result = new(:name => name)
    unless result.save
      result = find(:first, :conditions => ["name = ?", name])
    end
    return result
  end

  def waitnum
    Wish.count(:all, :conditions => ["activity_id =?", id])
  end
end
