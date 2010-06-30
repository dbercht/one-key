class AdvisorSessionsController < ApplicationController
  def new
    @advisor_session = AdvisorSession.new
  end

  def create
    @advisor_session = AdvisorSession.new(params[:advisor_session])
    if @advisor_session.save
      flash[:notice] = "Login successful!"
      redirect_to root_url
    else
      render :action => :new
    end
  end

  def destroy
    current_admin_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to root_url
  end
end
