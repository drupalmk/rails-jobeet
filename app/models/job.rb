class Job < ActiveRecord::Base
  
  JOB_TYPES = { fulltime: 'Full time', parttime: 'Part time', freelance: 'Freelance' }
  
  JOB_UPLOADS_DIR = Rails.root.join('public', 'upload', 'jobs')

  belongs_to :category

  validates_presence_of :job_type, :company, :position, 
                        :location, :description, :how_to_apply, :email, 
                        :message => "Must not be blank"

  attr_accessor :logo_file
  
  after_initialize :default_values
  
  def self.get_categories_with_jobs(limit)
    categories = Category.get_containing_jobs
    categories.each do |category|
      category.active_jobs = self.get_jobs_by_category(category.id, limit)
    end
    return categories
  end

  def self.get_jobs_by_category(id, limit)
    self.where("category_id = ? AND is_activated = True AND expires_at > ?", id, DateTime.now)
        .order("expires_at desc")
        .limit(limit)
  end
  
  def upload
     unless self.logo_file.nil?
       o =  [('a'..'z')].map{|i| i.to_a}.flatten
       random_name  =  (0..12).map{ o[rand(o.length)] }.join
       file_ext = File.extname(self.logo_file.original_filename)
       new_logo_filename = random_name + file_ext
       
       delete_upload
       FileUtils.copy_file(self.logo_file.tempfile, Rails.root.join(Job::JOB_UPLOADS_DIR, new_logo_filename))
       
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
    self.upload
    super
  end
  
  def delete
    delete_upload
    super
  end
  
  private
    def default_values
      self.job_type ||= 'fulltime'
      self.is_activated |= false
    end
    
    def delete_upload
      if not self.logo.nil?
        File.delete(Rails.root.join(Job::JOB_UPLOADS_DIR, self.logo))
        self.logo = nil
      end
    end
end
