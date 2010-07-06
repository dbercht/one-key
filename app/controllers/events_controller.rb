class EventsController < ApplicationController
  before_filter :require_login

  def new
    @event = Event.new(:period => "Does not repeat")  
  end
  
  def create
    if params[:event][:period] == "Does not repeat"
      @event = Event.new(params[:event])
      if(current_advisor)
        @event.advisor_id = current_advisor.id
        @event.title = current_advisor.name
      elsif(current_student)
        @event.advisor_id = current_student.advisor_id
        @event.student_id = current_student.id
        @event.title = current_student.name
      end
    else
      #      @event_series = EventSeries.new(:frequency => params[:event][:frequency], :period => params[:event][:repeats], :starttime => params[:event][:starttime], :endtime => params[:event][:endtime], :all_day => params[:event][:all_day])
      @event_series = EventSeries.new(params[:event])
    end

  end
  
  def index
    if(current_student)
      render "index_students"
    elsif(!current_advisor)
      flash[:notice] = "Must be logged in to see this page"
      redirect_to :controller => "students", :action => "new"
    end
  end

  def index_students

  end
  
  
  def get_events

    @events = Event.find(:all, :conditions => ["starttime >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and endtime <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
    @events.delete_if {|x| x.advisor_id != return_id }
    events = []
    @events.each do |event|
      events << {:id => event.id, :title => event.title, :description => event.description || "Some cool description here...", :start => "#{event.starttime.iso8601}", :end => "#{event.endtime.iso8601}", :allDay => event.all_day, :recurring =>  false}
    end
    render :text => events.to_json
  end    
  
  def move
    @event = Event.find_by_id params[:id]
    if(current_student) 
      if(@event.student_id == current_student.id)
        if @event
          @event.starttime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.starttime))
          @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
          @event.all_day = params[:all_day]
          @event.save
        end
      end
    end

    if(current_advisor) 
      if(@event.advisor_id == current_advisor.id)
        if @event
          @event.starttime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.starttime))
          @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
          @event.all_day = params[:all_day]
          @event.save
        end
      end
    end
    
    
    render :update do |page|
      page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
      page<<"$('#desc_dialog').dialog('destroy')" 
    end
  end
  
  
  def resize
    @event = Event.find_by_id params[:id]
    if @event
      @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
      @event.save
    end    
  end
  
  def edit
    @event = Event.find_by_id(params[:id])
  end
  
  def update
    @event = Event.find_by_id(params[:event][:id])
    if params[:event][:commit_button] == "Update All Occurrence"
      @events = @event.event_series.events #.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    elsif params[:event][:commit_button] == "Update All Following Occurrence"
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    else
      @event.attributes = params[:event]
      @event.save
    end

    render :update do |page|
      page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
      page<<"$('#desc_dialog').dialog('destroy')" 
    end
    
  end  
  
  def destroy
    @event = Event.find_by_id(params[:id])
    if params[:delete_all] == 'true'
      @event.event_series.destroy
    elsif params[:delete_all] == 'future'
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.event_series.events.delete(@events)
    else
      if(@event.student_id == current_student.id)
        @event.destroy 
        redirect_to student_path(@student)
      elsif(@event.advisor_id == current_advisor.id)
        @event.destroy
        render :update do |page|
          page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
          page<<"$('#desc_dialog').dialog('destroy')" 
        end
      end
    end

    
  end
  
end
