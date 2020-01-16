#Fedena
#Copyright 2011 Foradian Technologies Private Limited
#
#This product includes software developed at
#Project Fedena - http://www.projectfedena.org/
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

class EmployeeAttendancesController < ApplicationController
  before_filter :login_required,:configuration_settings_for_hr
  filter_access_to :all
  
  def index
    @departments = EmployeeDepartment.active_and_ordered
  end

  def show
    @dept = EmployeeDepartment.find(params[:dept_id])
    @employees = Employee.find_all_by_employee_department_id(@dept.id)
    unless params[:next].nil?
      @today = params[:next].to_date
    else
      @today = Date.today
    end
    @start_date = @today.beginning_of_month
    @end_date = @today.end_of_month
    respond_to do |format|
      format.js {render :action => 'show'}
    end
  end

  def new
    @attendance = EmployeeAttendance.new
    @employee = Employee.find(params[:id2])
    @date = params[:id]
    @leave_types = EmployeeLeaveType.find(:all,:joins => :employee_leaves, :conditions=>["status = true AND employee_leaves.employee_id = ? AND employee_leaves.reset_date IS NOT NULL",@employee.id])
    respond_to do |format|
      format.js {render :action => 'new'}
    end
  end

  def create
    @attendance = EmployeeAttendance.new(params[:employee_attendance])
    @employee = Employee.find(params[:employee_attendance][:employee_id])
    @date = params[:employee_attendance][:attendance_date]
    @reset_count = EmployeeLeave.find_by_employee_id(@attendance.employee_id, :conditions=> "employee_leave_type_id = '#{@attendance.employee_leave_type_id}'")
    if @attendance.save
      leaves_taken = @reset_count.leave_taken
      if @attendance.is_half_day
        leave = leaves_taken.to_f+(0.5)
        @reset_count.update_attributes(:leave_taken => leave)
      else
        leave = leaves_taken.to_f+(1)
        @reset_count.update_attributes(:leave_taken => leave)
      end
      respond_to do |format|
        format.js {render :action => 'create'}
      end
    else
      @error = true
    end
  end

  def edit
    @attendance = EmployeeAttendance.find(params[:id])
    date = @attendance.attendance_date
    @employee_leave = EmployeeLeave.find_by_employee_id_and_employee_leave_type_id(@attendance.employee_id,@attendance.employee_leave_type_id)
    @employee = Employee.find(@attendance.employee_id)
    @leave_types = EmployeeLeaveType.find(:all,:joins => :employee_leaves, :conditions=>["status = true AND employee_leaves.employee_id = ? AND employee_leaves.reset_date IS NOT NULL",@employee.id])
    @application_count = ApplyLeave.count(:conditions => ["(employee_id = ? AND approved = ?) AND ((? BETWEEN start_date AND end_date) OR (? BETWEEN start_date AND end_date) OR (start_date BETWEEN ? AND ?) OR (end_date BETWEEN ? AND ?))",@employee.id,true,date,date,date,date,date,date])
    respond_to do |format|
      format.js {render :action => 'edit'}
    end
  end

  def update
    @attendance = EmployeeAttendance.find params[:id]
    @employee = Employee.find(@attendance.employee_id)
    date = @attendance.attendance_date
    @reset_count = EmployeeLeave.find_by_employee_id(@attendance.employee_id, :conditions=> "employee_leave_type_id = '#{@attendance.employee_leave_type_id}'")
    leaves_taken = @reset_count.leave_taken
    day_status = @attendance.is_half_day
    leave_type = EmployeeLeaveType.find_by_id(@attendance.employee_leave_type_id)
    @application_count = ApplyLeave.count(:conditions => ["(employee_id = ? AND approved = ?) AND ((? BETWEEN start_date AND end_date) OR (? BETWEEN start_date AND end_date) OR (start_date BETWEEN ? AND ?) OR (end_date BETWEEN ? AND ?))",@employee.id,true,date,date,date,date,date,date])
    if @attendance.is_half_day
      half_day = true
    else
      half_day = false
    end
    respond_to do |format|
      if @attendance.update_attributes(params[:employee_attendance])
        if @attendance.employee_leave_type_id == leave_type.id
          unless day_status == @attendance.is_half_day
            if half_day
              leave = leaves_taken.to_f+(0.5)
            else
              leave = leaves_taken.to_f-(0.5)
            end
            @reset_count.update_attributes(:leave_taken => leave)
          end
        else
          if half_day
            leave = leaves_taken.to_f-(0.5)
          else
            leave = leaves_taken.to_f-(1.0)
          end
          @reset_count.update_attributes(:leave_taken => leave)
          @new_reset_count = EmployeeLeave.find_by_employee_id(@attendance.employee_id, :conditions=> "employee_leave_type_id = '#{@attendance.employee_leave_type_id}'")
          leaves_taken = @new_reset_count.leave_taken
          if @attendance.is_half_day
            leave = leaves_taken.to_f+(0.5)
            @new_reset_count.update_attributes(:leave_taken => leave)
          else
            leave = leaves_taken.to_f+(1)
            @new_reset_count.update_attributes(:leave_taken => leave)
          end
        end
        @employee = Employee.find(@attendance.employee_id)
        @date = @attendance.attendance_date
      else
        @error=true
      end
      format.js {render :action => 'update'}
    end
  end

  def destroy
    @attendance = EmployeeAttendance.find(params[:id])
    @reset_count = EmployeeLeave.find_by_employee_id(@attendance.employee_id, :conditions=> "employee_leave_type_id = '#{@attendance.employee_leave_type_id}'")
    leaves_taken = @reset_count.leave_taken
    total_employee_leave = @reset_count.leave_count
    created_at = @attendance.created_at || @attendance.attendance_date.to_datetime
    reset_date = @reset_count.reset_date
    if created_at > reset_date
      if @attendance.is_half_day
        leave = leaves_taken - (0.5)
      else
        leave = leaves_taken - (1)
      end
      @reset_count.update_attributes(:leave_taken => leave)
    else
      if @attendance.is_half_day
        total_leave = total_employee_leave.to_f + (0.5)
      else
        total_leave = total_employee_leave.to_f + (1)
      end
      @reset_count.update_attributes(:leave_count => total_leave)
    end
    @attendance.delete
    respond_to do |format|
      @employee = Employee.find(@attendance.employee_id)
      @date = @attendance.attendance_date
      format.js {render :action => 'update'}
    end
  end
end
