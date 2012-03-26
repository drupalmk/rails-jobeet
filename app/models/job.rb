class Job < ActiveRecord::Base
  belongs_to :category
  
  JOB_TYPES = { fulltime: 'Full time', parttime: 'Part time', freelance: 'Freelance' }
  
  after_initialize :default_values

  def self.get_jobs_by_category(id, limit)
    self.where("category_id = ? AND expires_at > ?", id, DateTime.now)
        .order("expires_at desc")
        .limit(limit)
  end
  
  def save
    if self.created_at.nil?
      self.created_at = DateTime.now
      self.expires_at = self.created_at + Jobeet::Application::ACTIVE_DAYS
    else
      self.updated_at = DateTime.now
    end
    super
  end
  
  private
    def default_values
      self.job_type ||= 'fulltime'
      self.is_activated |= false
    end
end
