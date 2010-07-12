class StudentSessionsController < ApplicationController
  def new
    @student_session = StudentSession.new
  end

  def create
    @student_session = StudentSession.new(params[:student_session])
    if @student_session.save
      flash[:notice] = "Login successful!"
      redirect_to root_url
    else
      flash[:notice] = "Wrong login/password combination"
      render :action => :new
    end
  end

  def destroy
    current_student_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to root_url
  end
end
