class TimetableTrackerController < ApplicationController
  before_filter :login_required
  filter_access_to :all

  def index
    
  end

  def class_timetable_swap
    @batches=Batch.active.all(:include=>:course)
  end

  def batch_timetable
    unless params[:batch][:batch_id].blank?
      batch=Batch.find params[:batch][:batch_id]
      weekday=params[:batch][:date].to_date.strftime("%u").to_i
      weekday=0 if weekday==7
      @timetable_entries=batch.timetable_entries.all(:conditions=>["timetable_entries.weekday_id=#{weekday} and class_timings.is_deleted=0 and (timetables.start_date <= '#{params[:batch][:date].to_date}' and timetables.end_date >='#{params[:batch][:date].to_date}')"],:joins=>[:class_timing,:timetable],:order=>'start_time ASC',:include=>[:class_timing,:employees,{:timetable_swaps=>[:employee,:subject]}])
      @timetable_swaps=TimetableSwap.all(:conditions=>{:date=>params[:batch][:date],:timetable_entry_id=>@timetable_entries.collect(&:id)},:include=>[:employee,:subject]).group_by(&:timetable_entry_id)
      render :update do |page|
        page.replace_html "timetable", :partial => "batch_timetable"
        page.replace_html "error", :text => ""
      end
    else
      flash[:warn_notice]="#{t('batch_cant_be_blank')}"
      render :update do |page|
        page.replace_html "error", :partial => "error"
      end
    end
  end

  def timetable_swap_from
    batch=Batch.find params[:batch_id]
    @subjects=batch.subjects.active.all(:conditions=>{:elective_group_id=>nil})
    @departments = EmployeeDepartment.ordered(:joins=>[{:employees=>:employees_subjects}]).uniq
    render :update do |page|
      page.replace_html "link_#{params[:timetable_entry_id]}", :partial => "timetable_swap_form"
    end
  end

  def list_employees
    @employees=Employee.all(:joins=>[:employee_department,:employees_subjects],:conditions=>{:employee_departments=>{:id=>params[:department_id]}}).uniq
    render :update do |page|
      page.replace_html "employee_list_#{params[:timetable_entry_id]}", :partial => "list_employees"
    end
  end

  def timetable_swap
    error=true
    if params[:timetable_swap_id].nil?
      @timetable_swap=TimetableSwap.new(:date=>params[:date],:timetable_entry_id=>params[:timetable_entry_id],:employee_id=>params[:timetable][:employee_id],:subject_id=>params[:timetable][:subject_id])
      if @timetable_swap.save
        error=false
      end
    else
      @timetable_swap=TimetableSwap.find params[:timetable_swap_id]
      if @timetable_swap.update_attributes(:date=>params[:date],:timetable_entry_id=>params[:timetable_entry_id],:employee_id=>params[:timetable][:employee_id],:subject_id=>params[:timetable][:subject_id])
        error=false
      end
    end
    unless error
      render :update do |page|
        page.replace_html "entry_#{params[:timetable_entry_id]}", :partial => "new_timetable_entry"
        page.replace_html "error", :text => ""
      end
    else
      render :update do |page|
        page.replace_html "error", :partial => "error"
      end
    end
  end

  def timetable_swap_delete
    @timetable_swap=TimetableSwap.find params[:timetable_swap_id]
    if @timetable_swap.destroy
      render :update do |page|
        page.replace_html "entry_#{params[:timetable_entry_id]}", :partial => "timetable_swap_delete"
      end
    else
      render :update do |page|
        page.replace_html "error", :partial => "error"
      end
    end
  end

  def swaped_timetable_report
    @date={}
    @date[:from]=Date.today
    @date[:to]=Date.today
    @employees=swaped_timetable_details(@date)
    if request.xhr?
      @date=params[:employee_details]
      @employees=swaped_timetable_details(@date)
      render :update do |page|
        page.replace_html "information", :partial => "employee_details"
      end
    end
  end

  def employee_report_details
    @over_time_details=TimetableSwap.all(:conditions=>{:employee_id=>params[:employee_id],:date=>params[:date][:from].to_date.beginning_of_day..params[:date][:to].to_date.end_of_day},
      :include=>[:employee,:subject,{:timetable_entry=>[:employees,:entry,:class_timing,{:batch=>:course}]}])
    @lagging_details=TimetableEntry.all(:select=>"timetable_entries.*,ts.date",
      :conditions=>{"ttte.employee_id"=>params[:employee_id],"ts.date"=>params[:date][:from].to_date.beginning_of_day..params[:date][:to].to_date.end_of_day},
      :joins=>"INNER JOIN timetable_swaps ts ON ts.timetable_entry_id = timetable_entries.id
INNER JOIN teacher_timetable_entries ttte ON ttte.timetable_entry_id = timetable_entries.id",
      :include=>[:employees,:class_timing,{:batch=>:course},{:timetable_swaps=>[:subject,:employee]}])
    p @lagging_details
    render :update do |page|
      page.replace_html "list_#{params[:employee_id]}", :partial => "employee_report_details"
    end
  end

  def swaped_timetable_report_csv
    employees=swaped_timetable_details(params[:employee_details])
    csv_string=FasterCSV.generate do |csv|
      cols=["#{t('employee_text')}","#{t('department')}","#{t('replacement_status')}"]
      csv << cols
      employees.each do |employee|
        col=[]
        col<< "#{employee.first_name} #{employee.middle_name} #{employee.last_name} - #{employee.emp_id}"
        col<< "#{employee.department}"
        count=[]
        unless employee.over_time.blank?
          count<< "#{employee.over_time} + "
        end
        unless employee.lagging.blank?
          count<< "#{employee.lagging} -"
        end
        col << count.join("  ")
        col=col.flatten
        csv<< col
      end
    end
    filename = "#{t('swaped_timetable')} #{t('report')}-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
  end
  
end
private

def swaped_timetable_details(date)
  employees_ot=TimetableSwap.all(:select=>"employees.first_name,employees.last_name,employees.middle_name,employees.id as eid,count(employees.id) as over_time,employee_departments.name as department,employees.employee_number as emp_id",:group=>"employee_id",:joins=>{:employee=>:employee_department},:conditions=>{:date=>date[:from].to_date.beginning_of_day..date[:to].to_date.end_of_day})
  employees_lag=TimetableEntry.all(:select=>"employees.first_name,employees.last_name,employees.middle_name,employees.employee_number as emp_id,employees.id as eid ,count(timetable_entries.id) as lagging , employee_departments.name as department",:joins=>[{:employees=>:employee_department},:timetable_swaps],:group=>"employees.id",:conditions=>{:timetable_swaps=>{:date=>date[:from].to_date.beginning_of_day..date[:to].to_date.end_of_day}})
  emp_lag=employees_lag.group_by(&:emp_id)
  emp_ot=employees_ot.group_by(&:emp_id)
  employees_ot.each do|emp|
    emp["lagging"] = emp_lag[emp.emp_id].nil? ? "" : emp_lag[emp.emp_id][0].lagging
  end
  employees_lag.each do |emp|
    emp["over_time"] = emp_ot[emp.emp_id].nil? ? "" : emp_ot[emp.emp_id][0].over_time
  end
  employees=employees_ot+employees_lag
  employees= Hash[*(employees).map {|obj| [obj.emp_id, obj]}.flatten].values
  employees=employees.sort_by{|emp| emp.first_name.downcase}
  return employees
end