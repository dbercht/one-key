class StudentsController < ApplicationController
 def new  
   @student = Student.new  
 end  

 def show
    if(current_advisor)
      @student = Student.find(params[:id])
    elsif(current_student)
      @student = Student.find(current_student.id)
    else
      redirect_to root_url
    end
 end
   
 def create  
   @student = Student.new params[:student]  
   if @student.save  
     flash[:notice] = "#{@student.email} successfully registered!"  
     redirect_to root_url
   else  
     flash[:error] = @student.errors.full_messages
     render :new  
   end
 end  

 def edit  
   @student = Student.find params[:id]  
 end  
   
 def update  
   @student = Student.find params[:id]  
   if @student.update_attributes(params[:student])  
     flash[:notice] = "#{@student.name} saved." 
     redirect_to @student  
   else  
     render :edit  
   end  
 end 

 def destroy  
   @student = Student.find params[:id]  
   @student.destroy  
   flash[:notice] = "#{@student.email} deleted."  
   redirect_to root_url  
 end  

end
