class Job < ActiveRecord::Base
  belongs_to :category
  
  JOB_TYPES = { fulltime: 'Full time', parttime: 'Part time', freelance: 'Freelance' }
  
  def self.get_jobs_by_category(id, limit)
    self.where("category_id = ? AND expires_at > ?", id, DateTime.now)
        .order("expires_at desc")
        .limit(limit)
  end
end
