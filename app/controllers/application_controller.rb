# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  filter_parameter_logging :password, :password_confirmation
  helper_method :student_has_appointment, :advisor_id, :student_id, :require_login, :current_advisor_session, :current_advisor, :current_student_session, :current_student, :return_id

  private
  def require_login
    return(current_student || current_advisor)
  end

  def student_has_appointment
    return(current_student.event != nil)
  end

  def student_id
    return(@id)if defined?(current_student)
    @id = current_student.id
    
  end

  def advisor_id
    return(@id)if defined?(current_advisor)
    @id = current_advisor.id
  end
  
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

  def return_id
    return @fetch_id if defined?(@fetch_id)
      if(current_student)
        @fetch_id = current_student.advisor_id
      elsif (current_advisor)
        @fetch_id = current_advisor.id
      end
  end

  def allowed
    return(current_advisor)
  end


end
