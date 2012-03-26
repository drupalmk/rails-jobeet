require 'test_helper'

class JobTest < ActiveSupport::TestCase
  
  def setup
    @job = create_job
  end
  
  def teardown
    @job.delete
  end
  
  test "job logo_file_save" do
    upload = ActionDispatch::Http::UploadedFile.new({
                  :filename => 'sensio-labs.gif',
                  :content_type => 'image/gif',
                  :tempfile => File.new("#{Rails.root}/test/fixtures/sensio-labs.gif")
             })

    @job.logo_file = upload
    stored_file_name = @job.upload

    assert_not_nil stored_file_name
    assert_equal true, File::exists?(Rails.root.join(Job::JOB_UPLOADS_DIR, stored_file_name))
    
    @job.delete
    assert_equal false, File::exists?(Rails.root.join(Job::JOB_UPLOADS_DIR, stored_file_name))

  end
  
  test "job creation date" do
    @job.save
    created_at = @job.created_at
    @job.reload
    assert_not_nil created_at
    assert_not_nil @job.created_at
    assert_equal created_at.to_s, @job.created_at.to_s
  end

  test "job expires date" do
    @job.save
    assert_equal @job.created_at, @job.expires_at - Jobeet::Application::ACTIVE_DAYS
  end
  
  test "job update date" do
    @job.save
    @job.company = 'New Company'
    now = DateTime.now
    @job.save
    assert_equal @job.updated_at, now
  end
  
  def create_job
    job = Job.new
    job.job_type = 'fulltime'
    job.company = 'Acme'
    job.description = 'Some description'
    job.how_to_apply = 'Send resume'
    job.email = 'jobs@acme.com'
    job.location = 'Paris, France'
    job.is_public = true
    return job
  end
end
