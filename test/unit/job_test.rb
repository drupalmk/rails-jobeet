require 'test_helper'

class JobTest < ActiveSupport::TestCase
  
  def setup
    @job = create_job
  end
  
  def teardown
    @job.delete
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
