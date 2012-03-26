class Job < ActiveRecord::Base
  
  belongs_to :category
  
  JOB_TYPES = { fulltime: 'Full time', parttime: 'Part time', freelance: 'Freelance' }
  
  JOB_UPLOADS_DIR = Rails.root.join('public', 'upload', 'jobs')
  
  attr_accessor :logo_file
  
  after_initialize :default_values

  def self.get_jobs_by_category(id, limit)
    self.where("category_id = ? AND expires_at > ?", id, DateTime.now)
        .order("expires_at desc")
        .limit(limit)
  end
  
  def upload
     unless self.logo_file.nil?
       o =  [('a'..'z')].map{|i| i.to_a}.flatten
       random_name  =  (0..12).map{ o[rand(o.length)] }.join
       file_ext = File.extname(self.logo_file.tempfile)
       new_logo_filename = random_name + file_ext
       
       FileUtils.copy_file(self.logo_file.tempfile, Rails.root.join(Job::JOB_UPLOADS_DIR, new_logo_filename))

       File.delete(Rails.root.join(Job::JOB_UPLOADS_DIR, self.logo)) unless self.logo.nil?

       self.logo = new_logo_filename
       self.logo_file = nil

       return new_logo_filename
     end
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
