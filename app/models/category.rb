class Category < ActiveRecord::Base
  has_many :jobs
  
  attr_accessor :active_jobs

  def self.get_containing_jobs
    self.find :all, :joins => "INNER JOIN `jobs` ON jobs.category_id = categories.id", :group => :id
  end
  
end
