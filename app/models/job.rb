class Job < ActiveRecord::Base
  belongs_to :category
  
  JOB_TYPES = { fulltime: 'Full time', parttime: 'Part time', freelance: 'Freelance' }
end
