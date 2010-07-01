class StudentsController < ApplicationController
 def new  
   @student = Student.new  
 end  
   
 def create  
   @student = Student.new params[:student]  
   if @student.save  
     flash[:notice] = "#{@student.email} successfully registered!"  
     redirect_to root_url
   else  
     render :new  
   end
 end  
end
