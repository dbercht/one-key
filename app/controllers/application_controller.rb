# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_advisor_session, :current_advisor, :current_student_session, :current_student

  private
  def current_advisor_session
    return @current_advisor_session if defined?(@current_advisor_session)
    @current_advisor_session = AdvisorSession.find
  end

  def current_advisor
    return @current_advisor if defined?(@current_advisor)
    @current_advisor = current_advisor_session && current_advisor_session.advisor
  end
  
  def current_student_session
    return @current_student_session if defined?(@current_student_session)
    @current_student_session = StudentSession.find
  end

  def current_student
    return @current_student if defined?(@current_student)
    @current_student = current_student_session && current_student_session.student
  end

end
