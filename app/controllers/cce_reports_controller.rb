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

class CceReportsController < ApplicationController
  before_filter :login_required
  #  before_filter :load_cce_report, :only=>[:show_student_wise_report]
  filter_access_to :all, :except=>[:index,:student_wise_report,:student_report_pdf,:student_transcript,:student_report,
    :assessment_wise_report,:list_batches,:generated_report,:generated_report_csv,:generated_report_pdf,:subject_wise_report,
    :subject_wise_batches,:list_subjects,:subject_wise_generated_report,
    :subject_wise_generated_report_csv,:subject_wise_generated_report_pdf]
  #  filter_access_to :show_student_wise_report, :attribute_check => true

  filter_access_to [:index,:student_wise_report,:student_report_pdf,:student_transcript,:student_report,
    :assessment_wise_report,:list_batches,:generated_report,:generated_report_csv,:generated_report_pdf,:subject_wise_report,
    :subject_wise_batches,:list_subjects,:subject_wise_generated_report,:create_reports,:consolidated_report,:cbse_report,:cbse_scholastic_report,:cbse_co_scholastic_report,:cbse_co_scholastic_report,:batch_student_report,
    :subject_wise_generated_report_csv,:subject_wise_generated_report_pdf], :attribute_check=>true, :load_method => lambda { current_user }

  def index

  end


  def create_reports
    @courses = Course.cce
    if request.post?
      unless params[:course][:batch_ids].blank?
        errors = []
        batches = Batch.find_all_by_id(params[:course][:batch_ids])
        batches.each do |batch|
          if batch.check_credit_points
            batch.job_type = "3"
            Delayed::Job.enqueue(batch)
            batch.delete_student_cce_report_cache
          else
            errors += ["Incomplete grading level credit points for #{batch.full_name}, report generation failed."]
          end
        end
        flash[:notice]="Report generation in queue for batches #{batches.collect(&:full_name).join(", ")}. <a href='/scheduled_jobs/Batch/3'>Click Here</a> to view the scheduled job."
        flash[:error]=errors
      else
        flash[:notice]="No batch selected"
      end
    end

  end
  def student_wise_report
    @all_batches=[]
    @batches=[]
    if @current_user.has_exam_privileges?
      @batches=Batch.cce
    elsif @current_user.has_required_batches?
      @current_user.employee_record.batches.each do |batch|
        @batches<<batch if batch.course.grading_type=="3" and batch.course.is_deleted==false
      end
    elsif @current_user.has_required_subjects?
      @current_user.employee_record.subjects.each do |subject|
        @all_batches<<subject.batch if subject.batch.course.grading_type=="3" and subject.batch.course.is_deleted==false
      end
      @all_batches.uniq.each do |batch|
        @batches<<batch
      end
    else
      @batches=[]
    end
    if request.post?
      if params[:batch_id].present?
        @batch=Batch.find(params[:batch_id])
        @cce_categories=@batch.cce_exam_category
        @cce_cat_id=params[:cat_id].to_i if params[:cat_id].present?
        @check_term="all"
        if params[:cat_id].present? and @cce_cat_id!=0
          first_cce_exam_category_id=@batch.fetch_first_cce_exam_category
          if first_cce_exam_category_id==@cce_cat_id
            @check_term="first_term"
          else
            @check_term="second_term"
          end
        end

        @students=@batch.students.all(:order=>"first_name ASC")
        @student = @students.first
        if @student
          fetch_report
        end
        unless @check_term=="all"
          @exam_groups=@exam_groups.find_all_by_cce_exam_category_id(@cce_cat_id)
        end
        render(:update) do |page|
          page.replace_html  'list_cce_category', :partial=>"list_cce_exam_cataegory"  unless params[:ref_from].present?
          page.replace_html   'student_list', :partial=>"student_list", :object=>[@students,@cce_cat_id]
          @student.nil? ? (page.replace_html   'report', :text=>"") : (page.replace_html   'report', :partial=>"student_report")
          page.replace_html   'hider', :text=>""
        end
      else
        render(:update) do |page|
          page.replace_html  'list_cce_category', :text=>""
          page.replace_html   'student_list', :text=>""
          page.replace_html   'report', :text=>""
          page.replace_html   'hider', :text=>""
        end
      end
    end
  end

  def cce_full_exam_report
    @student=Student.find(params[:id])
    @batch=@student.batch
    @exam_groups=@batch.exam_groups.all(:joins=>:cce_exam_category)
    @data_hash = CceReport.fetch_student_wise_report(params)
    @grading_levels = GradingLevel.default
    @grade_sets=CceGradeSet.all
    fetch_attendance_data
    fetch_report
    render :pdf =>"cce_full_exam_report" ,:header =>{:content=>nil},:margin=>{:left=>10,:right=>0,:top=>10,:bottom=>5}, :show_as_html=>params[:d].present?
  end

  def student_report
    @check_term=params[:check_term]
    @cce_cat_id=params[:cce_cat_id].to_i
    @student = Student.find(params[:student])
    @batch=@student.batch
    fetch_report
    unless @check_term=="all"
      @exam_groups=@exam_groups.find_all_by_cce_exam_category_id(@cce_cat_id)
    end
    render(:update) do |page|
      page.replace_html   'report', :partial=>"student_report"
    end
  end

  def student_report_pdf
    @data_hash = CceReport.fetch_student_wise_report(params)
    @check_term=params[:check_term]
    if params[:cat_id].present?
      @data_hash[:exam_groups].reject!{ |k|  k.cce_exam_category_id!=params[:cat_id].to_i}
    end
    render :pdf => "#{@data_hash[:student].first_name}-CCE_Report"
  end

  def batch_student_report
    @reports=BatchWiseStudentReport.all(:order=>'id desc')
  end

  def new_batch_wise_student_report
    @courses=[]
    if @current_user.has_exam_privileges?
      @courses=Course.cce
    elsif @current_user.has_required_batches?
      @current_user.employee_record.batches.each do |batch|
        @courses<<batch.course if batch.course.grading_type=="3" and batch.course.is_deleted==false
      end
    elsif @current_user.has_required_subjects?
      @current_user.employee_record.subjects.each do |subject|
        @batches<<subject.batch if subject.batch.course.grading_type=="3" and subject.batch.course.is_deleted==false
      end
      @batches.uniq.each do |batch|
        @courses<<batch.course
      end
    else
      @courses=[]
    end
  end

  def generate_batch_student_report
    parameters = {:batch_ids => params[:batch_ids], :report_type => params[:report_type]}
    batch_student_report=BatchWiseStudentReport.new(:parameters=>parameters,:status=>'in queue',:course_id=>params[:course][:course_id])
    if batch_student_report.save
      Delayed::Job.enqueue(batch_student_report)
    end
    redirect_to :action=>'batch_student_report'
  end

  def batch_wise_student_report_download
    @report = BatchWiseStudentReport.find(params[:id])
    send_file(@report.report.path)
  end

  def student_transcript
    @check_term="all"
    @student= (params[:type]=="former" ? ArchivedStudent.find(params[:id]) : Student.find(params[:id]))
    @type= params[:type] || "regular"
    @batch=(params[:batch_id].blank? ? @student.batch : Batch.find(params[:batch_id]))
    @batches=@student.all_batches.reverse unless request.xhr?
    @student.batch_in_context_id = @batch.id
    fetch_report
    if request.xhr?
      render(:update) do |page|
        page.replace_html   'report', :partial=>"student_report"
      end
    end
  end
  def consolidated_report
    @courses=[]
    @batches=[]
    @exam_groups=[]
    if @current_user.has_exam_privileges?
      @courses=Course.cce
    elsif @current_user.has_required_batches?
      @current_user.employee_record.batches.each do |batch|
        @courses<<batch.course if batch.course.grading_type=="3" and batch.course.is_deleted==false
      end
    elsif @current_user.has_required_subjects?
      @current_user.employee_record.subjects.each do |subject|
        @batches<<subject.batch if subject.batch.course.grading_type=="3" and subject.batch.course.is_deleted==false
      end
      @batches.uniq.each do |batch|
        @courses<<batch.course
      end
    else
      @courses=[]
    end
    @assessment_groups_cat_1=['FA1','FA2','FA3','FA4','SA1','SA2']
    @assessment_groups_cat_2=['SA1+SA2','FA1+FA2+FA3+FA4']
    @assessment_groups_cat_3=['FA1+FA2+SA1',"FA3+FA4+SA2"]
    @student_category=StudentCategory.active
  end

  def cbse_scholastic_report
    @courses=[]
    @batches=[]
    @exam_groups=[]
    @subjects=[]
    if @current_user.has_exam_privileges?
      @courses=Course.cce
    elsif @current_user.has_required_batches?
      @current_user.employee_record.batches.each do |batch|
        @courses<<batch.course if batch.course.grading_type=="3" and batch.course.is_deleted==false
      end
    elsif @current_user.has_required_subjects?
      @current_user.employee_record.subjects.each do |subject|
        @batches<<subject.batch if subject.batch.course.grading_type=="3" and subject.batch.course.is_deleted==false
      end
      @batches.uniq.each do |batch|
        @courses<<batch.course
      end
    else
      @courses=[]
    end

    @assessment_groups=['FA1','FA2','FA3','FA4','SA1','SA2']
    @student_category=StudentCategory.active
  end

  def cbse_co_scholastic_report
    @courses=[]
    @batches=[]
    @observation_group=[]
    @subjects=[]
    if @current_user.has_exam_privileges?
      @courses=Course.cce
    elsif @current_user.has_required_batches?
      @current_user.employee_record.batches.each do |batch|
        @courses<<batch.course if batch.course.grading_type=="3" and batch.course.is_deleted==false
      end
    elsif @current_user.has_required_subjects?
      @current_user.employee_record.subjects.each do |subject|
        @batches<<subject.batch if subject.batch.course.grading_type=="3" and subject.batch.course.is_deleted==false
      end
      @batches.uniq.each do |batch|
        @courses<<batch.course
      end
    else
      @courses=[]
    end

    @assessment_groups=['FA1','FA2','FA3','FA4','SA1','SA2']
    @student_category=StudentCategory.active
  end

  def generate_cbse_scholastic_report
    unless params[:assessment][:batch_id].blank?
      unless  params[:assessment][:exam_group_id].blank?
        unless params[:subject_report][:subject_id].blank?
          @batch_id=params[:assessment][:batch_id]
          @batch=Batch.find @batch_id
          @exam_group_id=params[:assessment][:exam_group_id]
          @exam_group=ExamGroup.find @exam_group_id
          @subject_id=params[:subject_report][:subject_id]
          @subject=Subject.find @subject_id
          fetch_cbse_scholastic_data
          render(:update) do |page|
            page.replace_html 'hider', :text=>''
            page.replace_html 'report_table', :partial=>'cbse_scholastic_report'
          end
        else
          flash[:warn_notice]="Select one Subject"
          error=true
        end
      else
        flash[:warn_notice]="Select Exam Group"
        error=true
      end
    else
      flash[:warn_notice]="Select one Batch"
      error=true
    end
    if error
      render(:update) do |page|
        page.replace_html 'hider', :partial=>'error'
        page.replace_html 'report_table', :text=>''
      end
    end
  end

  def generate_cbse_scholastic_report_csv

    @batch_id=params[:batch_id]
    batch=Batch.find(@batch_id)
    @exam_group_id=params[:exam_group_id]
    @subject_id=params[:subject_id]
    subject=Subject.find(@subject_id)
    exam_group=ExamGroup.find @exam_group_id
    fetch_cbse_scholastic_data
    csv_string=FasterCSV.generate do |csv|
      cols=[]
      cols << 'Session'
      cols << "#{batch.start_date.year}-#{batch.end_date.year}"
      cols << "  "
      cols << "EXAM"
      cols << "#{batch.name}-#{exam_group.name}"
      cols << "SUBJECT"
      cols << subject.name
      csv << cols
      cols=[]
      3. times do
        cols << " "
      end
      fa_category=@subject.fa_groups.all(:conditions=>{:cce_exam_category_id=>@exam_group.cce_exam_category_id})
      fa_category.each do |ag|
        cols << "#{ag.name.split.last}- MAX"
        cols << 100
        if (ag.name.split.last=="FA1" or ag.name.split.last=="FA2")
          @sa = "SA1"
        elsif (ag.name.split.last=="FA3" or ag.name.split.last=="FA4")
          @sa = "SA2"
        end
      end
      cols << "#{@sa} MAX"
      cols << @subject.exams.first(:joins=>'exams',:conditions=>{:exams=>{:exam_group_id=>@exam_group_id}}).maximum_marks
      csv << cols
      cols=[]
      3. times do
        cols << " "
      end
      fa_category.each do |ag|
        cols << "#{ag.name.split.last}"
        cols << ""
      end
      cols << @sa
      cols << ""
      csv << cols
      cols=[]
      cols << "BOARD REG. NO."
      cols << "ROLL NO"
      cols << "NAME"
      fa_category.each do |ag|
        cols << "obt."
        cols << "WT - " "#{ag.cce_exam_category.cce_weightages.first(:conditions=>{:criteria_type=>'FA'}).weightage}%"
        @sa=ag.cce_exam_category.cce_weightages.first(:conditions=>{:criteria_type=>'SA'}).weightage
      end
      cols << "obt."
      cols << "WT - #{@sa}%"
      csv << cols
      @students.each do |s|
        col=[]
        col << ""
        student_text = "#{s.full_name}"
        if Configuration.enabled_roll_number?
          col << (s.roll_number.present? ? s.roll_number : "NA")
        else
          col << ""
        end
        col<< student_text
        st=@fa_score_hash.find{|c,v| c==s.id}
        if st
          fa_1_2_set=false
          fa_3_4_set=false
          c1=0
          c2=0
          @subject.fa_groups.all(:conditions=>{:cce_exam_category_id=>@exam_group.cce_exam_category_id}).each do |ag|
            sc=@fa_score_hash[s.id][@subject.id.to_s]
            if sc
              col << @fa_score_hash[s.id][@subject.id.to_s][ag.name.split.last]['mark']
              mark=@fa_score_hash[s.id][@subject.id.to_s][ag.name.split.last]['mark']*(ag.cce_exam_category.cce_weightages.first(:conditions=>{:criteria_type=>'FA'}).weightage)
              mark = (mark.is_a?String) ? "-" : (mark/100).to_f.round(2)
              col << mark
              if (ag.name.split.last=="FA1" or ag.name.split.last=="FA2") and fa_1_2_set==false
                c1+=1
                if c1==2
                  col << @fa_score_hash[s.id][@subject.id.to_s]["SA1"]['mark']
                  mark=@fa_score_hash[s.id][@subject.id.to_s]["SA1"]['mark']*(ag.cce_exam_category.cce_weightages.first(:conditions=>{:criteria_type=>'SA'}).weightage)
                  mark = (mark.is_a?String) ? "-" : (mark/100).to_f.round(2)
                  col << mark
                  c1=0
                  fa_1_2_set=true
                end
              elsif (ag.name.split.last=="FA3" or ag.name.split.last=="FA4") and fa_3_4_set==false
                c2+=1
                if c2==2
                  col << @fa_score_hash[s.id][@subject.id.to_s]["SA2"]['mark']
                  mark=@fa_score_hash[s.id][@subject.id.to_s]["SA2"]['mark']*(ag.cce_exam_category.cce_weightages.first(:conditions=>{:criteria_type=>'SA'}).weightage)
                  mark=(mark.is_a?String) ? "-" : (mark/100).to_f.round(2)
                  col << mark
                  c2=0
                  fa_3_4_set=true
                end
              end
            else
              6.times do
                col << '-'
              end
            end
          end
        else
          6.times do
            col << '-'
          end
        end
        csv << col
      end
    end
    filename = "#{@batch.full_name}-#{params[:assessment_group]}-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
  end

  def generate_cbse_co_scholastic_report
    unless params[:assessment][:batch_id].blank?
      unless params[:subject_report][:observation_group_id].blank?
        @batch_id=params[:assessment][:batch_id]
        @batch=Batch.find @batch_id
        @observation_group_id=params[:subject_report][:observation_group_id]
        @observation_group=ObservationGroup.find @observation_group_id
        fetch_cbse_co_scholastic_data
        render(:update) do |page|
          page.replace_html 'hider', :text=>''
          page.replace_html 'report_table', :partial=>'cbse_co_scholastic_report'
        end
      else
        flash[:warn_notice]="Select one Observation Group"
        error=true
      end
    else
      flash[:warn_notice]="Select one Batch"
      error=true
    end
    if error
      render(:update) do |page|
        page.replace_html 'hider', :partial=>'error'
        page.replace_html 'report_table', :text=>''
      end
    end
  end

  def generate_cbse_co_scholastic_report_csv

    @batch_id=params[:batch_id]
    @batch=Batch.find @batch_id
    @observation_group_id=params[:observation_group_id]
    @observation_group=ObservationGroup.find @observation_group_id
    fetch_cbse_co_scholastic_data
    csv_string=FasterCSV.generate do |csv|
      heads=[]
      heads << "SESSION"
      heads << "#{@batch.start_date.year}-#{@batch.end_date.year}"
      heads << "EXAM"
      heads <<  @batch.name
      heads << ""
      heads << ""
      csv << heads
      cols = []
      cols << "BORDER REG.NO"
      cols << "ROLL NO"
      cols << "NAME"
      @co_hash[:ob_list].each do |o|
        cols << o.upcase
      end
      csv << cols
      @batch.students.each do |s|
        cols = []
        cols << "XXX"
        cols << ((s.roll_number.present?) ? "#{s.roll_number}" : '-')
        cols << s.full_name
        if @co_hash[s.id][:observations].present?
          @co_hash[s.id][:observations].sort{|a,b| a.last[:sort_order].to_i<=>b.last[:sort_order].to_i}.each do |o|
            cols << ((o.last[:grade].present?) ? o.last[:grade] : "-")
          end
        end
        csv << cols
      end
    end
    filename = "#{@batch.full_name}-#{params[:assessment_group]}-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
  end

  def list_batches
    unless params[:course_id].blank?
      course = Course.find(params[:course_id])
      if @current_user.has_exam_privileges?
        @batches=course.batches
      elsif @current_user.has_required_batches?
        @batches=@current_user.employee_record.batches.all(:conditions=>["course_id=?",course.id])
      elsif @current_user.has_required_subjects?
        @batches=[]
        @current_user.employee_record.subjects.each do |subject|
          @batches<<subject.batch if subject.batch.course_id==course.id
        end
      else
        @batches=[]
      end
      (params[:type]=="cbse_scolastic_report") ? @action="list_exam_groups" : params[:type]=="cbse_co_scholatic_report" ? @action="list_observation_groups" : @action=""
    else
      @batches=[]
    end
    render(:update) do |page|
      page.replace_html 'batch_select', :partial=>'batch_list' unless params[:type]=="batch_student_report"
      page.replace_html 'batch_select', :partial=>'batch_select_list',:locals=>{:batches=>@batches, :batch_ids=>@batches.collect(&:id).uniq} if params[:type]=="batch_student_report"
    end
  end

  def list_exam_groups
    if params[:subject_id].present?
      subject=Subject.find params[:subject_id]
      @exam_groups=subject.exams.all(:select=>"exam_groups.*",:joins=>[:exam_group=>:cce_exam_category])
    elsif  params[:batch_id].present?
      batch=Batch.find params[:batch_id]
      @exam_groups=batch.exam_groups(:joins=>:cce_exam_category)
    else
      @exam_groups=[]
    end
    params[:type]=="consolidated_report"? @action="set_assessment_group" : params[:type]=="cbse_scolastic_report" ? @action="list_subjects" : @action=""
    render(:update) do |page|
      page.replace_html 'exam_group_select', :partial=>'list_exam_groups'
    end
  end

  def list_observation_groups
    unless params[:batch]==""
      batch=Batch.find params[:batch_id]
      @observation_groups=batch.observation_groups.active
      render(:update) do |page|
        page.replace_html 'observation_group_select', :partial=>'list_observation_groups'
      end
    end
  end
  # for setting  assessment group
  def set_assessment_group
    unless params[:exam_group_id].blank?
      @assessment_groups=['FA1','FA2','FA3','FA4','SA1','SA2','SA1+SA2','FA1+FA2+FA3+FA4']
    else
      @assessment_groups=['FA1','FA2','FA3','FA4','SA1','SA2','SA1+SA2','FA1+FA2+FA3+FA4']
    end
  end

  def generated_report
    unless params[:assessment][:batch_id].blank?
      unless params[:assessment][:assessment_group].blank?
        @batch_id=params[:assessment][:batch_id]
        @student_category_id=params[:assessment][:student_category_id]
        @gender=params[:assessment][:gender]
        @assessment_group=params[:assessment][:assessment_group]
        @exam_group_id=params[:assessment][:exam_group_id]
        fetch_assessment_data
        render(:update) do |page|
          page.replace_html 'hider', :text=>''
          page.replace_html 'report_table', :partial=>'assessment_report'
        end
      else
        flash[:warn_notice]="Select one Assessment Group"
        error=true
      end
    else
      flash[:warn_notice]="Select one Batch"
      error=true
    end
    if error
      render(:update) do |page|
        page.replace_html 'hider', :partial=>'error'
        page.replace_html 'report_table', :text=>''
      end
    end
  end

  def generated_report_csv
    @batch_id=params[:batch_id]
    @student_category_id=params[:student_category_id]
    @gender=params[:gender]
    @assessment_group=params[:assessment_group]
    @exam_group_id=params[:exam_group_id]
    fetch_assessment_data
    csv_string=FasterCSV.generate do |csv|
      cols=[]
      csv << "Consolidated Report"
      cols << 'Students'
      heads=[]
      @subjects.collect(&:name).each{|h| heads << h ; heads << ""}
      cols<< heads
      cols=cols.flatten
      csv << cols
      cols=[]
      cols << ""
      @subjects.each{|s| cols<< "Grade" ; cols << "Mark(%)"}
      csv << cols
      @students.each do |s|
        col=[]
        student_text = "#{s.full_name}(#{s.admission_no})"
        if Configuration.enabled_roll_number?
          student_text = (s.roll_number.present? ? "#{s.roll_number} -" : '') + "#{s.full_name}"
        end
        col<< student_text
        st=@fa_score_hash.find{|c,v| c==s.id}
        if st
          @subjects.each do |sub|
            sc=@fa_score_hash[s.id][sub.id.to_s]
            if sc
              col << @fa_score_hash[s.id][sub.id.to_s]['grade']
              col << @fa_score_hash[s.id][sub.id.to_s]['mark']
            else
              col << "-"
              col << "-"
            end
          end
        else
          @subjects.each do |s|
            col << "-"
            col << "-"
          end
        end
        col=col.flatten
        csv<< col
      end
    end
    filename = "#{@batch.full_name}-#{params[:assessment_group]}-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
  end
  def generated_report_pdf
    @batch_id=params[:batch_id]
    @student_category_id=params[:student_category_id]
    @gender=params[:gender]
    @assessment_group=params[:assessment_group]
    @exam_group_id=params[:exam_group_id]
    fetch_assessment_data
    render :pdf=>'generated_report_pdf',:orientation => 'Landscape',:margin=>{:left=>10,:right=>10}
  end

  def subject_wise_report
    @batches=[]
    @courses=[]
    @subjects=[]
    @student_category=StudentCategory.active
    if @current_user.has_exam_privileges?
      @courses=Course.cce
    elsif @current_user.has_required_batches?
      @current_user.employee_record.batches.each do |batch|
        @courses<<batch.course if batch.course.grading_type=="3" and batch.course.is_deleted==false
      end
    elsif @current_user.has_required_subjects?
      @current_user.employee_record.subjects.each do |subject|
        @batches<<subject.batch if subject.batch.course.grading_type=="3" and subject.batch.course.is_deleted==false
      end
      @batches.uniq.each do |batch|
        @courses<<batch.course
      end
    else
      @courses=[]
    end
  end

  def subject_wise_batches
    unless params[:course_id].blank?
      course = Course.find(params[:course_id])
      if @current_user.has_exam_privileges?
        @batches=course.batches
      elsif @current_user.has_required_batches?
        @batches=@current_user.employee_record.batches.all(:conditions=>["course_id=?",course.id])
      elsif @current_user.has_required_subjects?

        @batches=[]
        @current_user.employee_record.subjects.each do |subject|
          @batches<<subject.batch if subject.batch.course_id==course.id
        end
      else
        @batches=[]
      end

    else
      @batches=[]
    end
    render(:update) do |page|
      page.replace_html 'batch_select', :partial=>'subject_wise_batches'
    end
  end

  def list_subjects
    unless params[:batch_id].blank?
      batch=Batch.find params[:batch_id]
      if @current_user.has_exam_privileges?
        @subjects=batch.subjects.active_and_has_exam
      elsif @current_user.has_required_batches?
        @subjects=batch.subjects.active_and_has_exam
      elsif @current_user.has_required_subjects?
        @subjects=@current_user.employee_record.subjects.active.all(:conditions=>{:batch_id=>batch.id,:no_exams=>false})
      else
        @subjects=[]
      end
    else
      if params[:exam_group_id].present?
        @exam_group=ExamGroup.find(params[:exam_group_id])
        if @current_user.has_exam_privileges?
          @subjects=@exam_group.batch.subjects.active_and_has_exam
        elsif @current_user.has_required_batches?
          @subjects=@exam_group.batch.subjects.active_and_has_exam
        elsif @current_user.has_required_subjects?
          @subjects=@current_user.employee_record.subjects.active.all(:conditions=>{:batch_id=>@exam_group.batch.id,:no_exams=>false})
        else
          @subjects=[]
        end
      else
        @subjects=[]
      end
    end
    render(:update) do |page|
      page.replace_html 'subject_select', :partial=>'list_subjects'
    end
  end

  def subject_wise_generated_report
    unless params[:subject_report][:batch_id].blank?
      unless params[:subject_report][:subject_id].blank?
        @batch_id=params[:subject_report][:batch_id]
        @subject_id=params[:subject_report][:subject_id]
        @student_category_id=params[:subject_report][:student_category_id]
        @gender= params[:subject_report][:gender]
        fetch_subject_wise_report
        render(:update) do |page|
          page.replace_html 'hider', :text=>''
          page.replace_html 'report_table', :partial=>'subject_wise_generated_report'
        end
      else
        error=true
        flash[:warn_notice]="Select one subject"
      end
    else
      error=true
      flash[:warn_notice]="Select one Batch"
    end
    if error
      render(:update) do |page|
        page.replace_html 'hider', :partial=>'error'
        page.replace_html 'report_table', :text=>''
      end
    end
  end

  def subject_wise_generated_report_csv
    @batch_id=params[:batch_id]
    @subject_id=params[:subject_id]
    @student_category_id=params[:student_category_id]
    @gender= params[:gender]
    fetch_subject_wise_report
    csv_string=FasterCSV.generate do |csv|
      cols=['Student','FA1','','FA2','','FA3','','FA4','','SA1','','SA2','']
      csv << cols
      cols=[]
      cols << ""
      6.times do
        cols << "Grade"
        cols << "Mark(%)"
      end
      csv << cols
      @students.each do |s|
        col=[]
        student_text = "#{s.full_name}(#{s.admission_no})"
        if Configuration.enabled_roll_number?
          student_text = (s.roll_number.present? ? "#{s.roll_number} -" : '') + "#{s.full_name}"
        end
        col<< student_text
        st=@score_hash.find{|c,v| c==s.id}
        if st
          if @score_hash[s.id][@fa1.to_s].nil?
            col<< "-"
            col<< "-"
          else
            col<< @score_hash[s.id][@fa1.to_s]['grade']
            col<< @score_hash[s.id][@fa1.to_s]['mark']
          end
          if @score_hash[s.id][@fa2.to_s].nil?
            col<< "-"
            col<< "-"
          else
            col<< @score_hash[s.id][@fa2.to_s]['grade']
            col<< @score_hash[s.id][@fa2.to_s]['mark']
          end
          if @score_hash[s.id][@fa3.to_s].nil?
            col<< "-"
            col<< "-"
          else
            col<< @score_hash[s.id][@fa3.to_s]['grade']
            col<< @score_hash[s.id][@fa3.to_s]['mark']
          end
          if @score_hash[s.id][@fa4.to_s].nil?
            col<< "-"
            col<< "-"
          else
            col<< @score_hash[s.id][@fa4.to_s]['grade']
            col<< @score_hash[s.id][@fa4.to_s]['mark']
          end
          if @score_hash[s.id][@sa1.to_s].nil?
            col<< "-"
            col<< "-"
          else
            col<< @score_hash[s.id][@sa1.to_s]['grade']
            col<< @score_hash[s.id][@sa1.to_s]['mark']
          end
          if @score_hash[s.id][@sa2.to_s].nil?
            col<< "-"
            col<< "-"
          else
            col<< @score_hash[s.id][@sa2.to_s]['grade']
            col<< @score_hash[s.id][@sa2.to_s]['mark']
          end
        else
          12.times.each do
            col << "-"
          end
        end
        col=col.flatten
        csv<< col
      end
    end
    filename = "#{@batch.full_name}-#{@subject.name}-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
  end

  def subject_wise_generated_report_pdf
    @batch_id=params[:batch_id]
    @subject_id=params[:subject_id]
    @student_category_id=params[:student_category_id]
    @gender= params[:gender]
    fetch_subject_wise_report
    render :pdf=>'generated_report_pdf',:orientation => 'Landscape'
  end


  private

  def fetch_attendance_data
    @attendance_hash={}
    config=Configuration.find_by_config_key('StudentAttendanceType')
    @exam_groups.each_with_index do |eg,i|
      unless config.config_value == 'Daily'
        i==0? month_date=@batch.start_date.to_date : month_date=(@exam_groups[i-1].exam_date.to_date+1).to_date
        end_date=eg.exam_date.to_date
        academic_days=@batch.subject_hours(month_date, end_date, 0).values.flatten.compact.count
        student_attendance= SubjectLeave.find(:all,:select=>"(#{academic_days}-count(DISTINCT IF(subject_leaves.month_date BETWEEN '#{month_date}' AND '#{end_date}' and subject_leaves.batch_id=#{@batch.id},subject_leaves.id,NULL))) as leaves,(#{academic_days}-count(DISTINCT IF(subject_leaves.month_date BETWEEN '#{month_date}' AND '#{end_date}' and subject_leaves.batch_id=#{@batch.id},subject_leaves.id,NULL)))/#{academic_days}*100 as percent",:conditions=>{:batch_id=>@batch.id,:student_id=>student_id}).first
        @attendance_hash[eg.id]={"percent"=>student_attendance.percent,"leaves"=>student_attendance.leaves.to_f,"academic_days"=>academic_days.to_f}
      else
        i==0? month_date=@batch.start_date.to_date : month_date=(@exam_groups[i-1].exam_date.to_date+1).to_date
        end_date=eg.exam_date.to_date
        working_days=@batch.date_range_working_days(month_date,end_date)
        academic_days=  working_days.select{|v| v<=end_date}.count
        student_attendance= Attendance.find(:all,:select => "(#{academic_days}-count(DISTINCT IF(attendances.forenoon=1 and attendances.afternoon=1 and attendances.batch_id=#{@batch.id} and `attendances`.`month_date` BETWEEN '#{month_date}' AND '#{end_date}',attendances.id,NULL))-(0.5*(count(DISTINCT IF(attendances.forenoon=1 and attendances.afternoon=0 and attendances.batch_id=#{@batch.id} and `attendances`.`month_date` BETWEEN '#{month_date}' AND '#{end_date}',attendances.id,NULL))+count(DISTINCT IF(attendances.afternoon=1 and attendances.forenoon=0 and attendances.batch_id=#{@batch.id} and `attendances`.`month_date` BETWEEN '#{month_date}' AND '#{end_date}',attendances.id,NULL))))) as leaves,(#{academic_days}-count(DISTINCT IF(attendances.forenoon=1 and attendances.afternoon=1 and attendances.batch_id=#{@batch.id} and `attendances`.`month_date` BETWEEN '#{month_date}' AND '#{end_date}',attendances.id,NULL))-(0.5*(count(DISTINCT IF(attendances.forenoon=1 and attendances.afternoon=0 and attendances.batch_id=#{@batch.id} and `attendances`.`month_date` BETWEEN '#{month_date}' AND '#{end_date}',attendances.id,NULL))+count(DISTINCT IF(attendances.afternoon=1 and attendances.forenoon=0 and attendances.batch_id=#{@batch.id} and `attendances`.`month_date` BETWEEN '#{month_date}' AND '#{end_date}',attendances.id,NULL)))))/#{academic_days}*100 as percent",:conditions => {:batch_id => @batch.id,:student_id=>@student.id}).first
        @attendance_hash[eg.id]={"percent"=>student_attendance.percent,"leaves"=>student_attendance.leaves.to_f,"academic_days"=>academic_days.to_f}
      end
    end
    return @attendance_hash
  end

  def fetch_report
    @report=@student.individual_cce_report_cached
    @subjects=@student.all_subjects.select{|x| x.exams.present?}
    @exam_groups=ExamGroup.find_all_by_id(@report.exam_group_ids, :include=>:cce_exam_category)
    coscholastic=@report.coscholastic
    @observation_group_ids=coscholastic.collect(&:observation_group_id)
    @observation_groups=ObservationGroup.find_all_by_id(@observation_group_ids,:order=>"sort_order asc").collect(&:name)
    @co_hash=Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    @obs_groups=@batch.observation_groups.all(:order=>"sort_order asc").to_a
    @og=@obs_groups.group_by(&:observation_kind)
    @co_hashi = {}
    @og.each do |kind, ogs|
      @co_hashi[kind]=[]
      coscholastic.each{|cs| @co_hashi[kind] << cs if ogs.collect(&:id).include? cs.observation_group_id}
    end
  end



  def fetch_assessment_data
    case @assessment_group
    when "FA1","FA2","FA3","FA4","SA1","SA2"
      calculate_assessment_data(@assessment_group)
    when "FA1+FA2+SA1"
      total_hash=Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
      total_hash.merge!(calculate_assessment_data('FA1'))
      fa1_keys=total_hash.collect{|k,v| k}
      fa2_hash=calculate_assessment_data('FA2')
      fa2_hash.reject!{|k,v| !fa1_keys.include?k}
      fa2_keys=fa2_hash.collect{|k,v| k}
      total_hash.reject!{|k,v| !fa2_keys.include?k}
      total_hash.merge!(fa2_hash){ |k, a_value, b_value| a_value.merge!(b_value){|k1, a1, b1| {"mark" => (a1["mark"]*a1["wightage"]/100).to_f + ((b1["mark"]*b1["wightage"])/100).to_f} } }
      sa1_hash=calculate_assessment_data('SA1')
      sa1_keys=sa1_hash.collect{|k,v| k}
      total_hash.reject!{|k,v| !sa1_keys.include?k}
      total_hash.merge!(sa1_hash){ |k, a_value, b_value| a_value.merge!(b_value){|k1, a1, b1| {"mark" => (a1["mark"]+ (b1["mark"]*b1["wightage"])/100).to_f}}}
      total_hash.each{|k,v| v.each{|k1,v1| v1['mark']=(((v1['mark'].to_f)*2)).round(2);v1['grade']=GradingLevel.percentage_to_grade(v1['mark'], @batch_id).present? ? GradingLevel.percentage_to_grade(v1['mark'], @batch_id) : '-'}}
      @fa_score_hash=total_hash
    when "FA3+FA4+SA2"
      total_hash=Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
      total_hash.merge!(calculate_assessment_data('FA3'))
      fa3_keys=total_hash.collect{|k,v| k}
      fa4_hash=calculate_assessment_data('FA4')
      fa4_hash.reject!{|k,v| !fa3_keys.include?k}
      fa4_keys=fa4_hash.collect{|k,v| k}
      total_hash.reject!{|k,v| !fa4_keys.include?k}
      total_hash.merge!(fa4_hash){ |k, a_value, b_value| a_value.merge!(b_value){|k1, a1, b1| {"mark" => (a1["mark"]*a1["wightage"]/100).to_f + ((b1["mark"]*b1["wightage"])/100).to_f} } }
      sa2_hash=calculate_assessment_data('SA2')
      sa2_keys=sa2_hash.collect{|k,v| k}
      total_hash.reject!{|k,v| !sa2_keys.include?k}
      total_hash.merge!(sa2_hash){ |k, a_value, b_value| a_value.merge!(b_value){|k1, a1, b1| {"mark" => (a1["mark"]+ (b1["mark"]*b1["wightage"])/100).to_f}}}
      total_hash.each{|k,v| v.each{|k1,v1| v1['mark']=(((v1['mark'].to_f)*2)).round(2);v1['grade']=GradingLevel.percentage_to_grade(v1['mark'], @batch_id).present? ? GradingLevel.percentage_to_grade(v1['mark'], @batch_id) : '-'}}
      @fa_score_hash=total_hash
    when "FA1+FA2+FA3+FA4"
      total_hash=Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
      total_hash.merge!(calculate_assessment_data('FA1'))
      fa1_keys=total_hash.collect{|k,v| k}
      fa2_hash=calculate_assessment_data('FA2')
      fa2_hash.reject!{|k,v| !fa1_keys.include?k}
      fa2_keys=fa2_hash.collect{|k,v| k}
      total_hash.reject!{|k,v| !fa2_keys.include?k}
      total_hash.merge!(fa2_hash){ |k, a_value, b_value| a_value.merge!(b_value){|k1, a1, b1| {"mark" => a1["mark"].to_f + b1["mark"].to_f,"grade" => a1["grade"]+b1["grade"]}}}
      fa2_keys=total_hash.collect{|k,v| k}
      fa3_hash=calculate_assessment_data('FA3')
      fa3_hash.reject!{|k,v| !fa2_keys.include?k}
      fa3_keys=fa3_hash.collect{|k,v| k}
      total_hash.reject!{|k,v| !fa3_keys.include?k}
      total_hash.merge!(fa3_hash){ |k, a_value, b_value| a_value.merge!(b_value){|k1, a1, b1| {"mark" => a1["mark"].to_f + b1["mark"].to_f,"grade" => a1["grade"]+b1["grade"]}}}
      fa3_keys=total_hash.collect{|k,v| k}
      fa4_hash=calculate_assessment_data('FA4')
      fa4_hash.reject!{|k,v| !fa3_keys.include?k}
      fa4_keys=fa4_hash.collect{|k,v| k}
      total_hash.reject!{|k,v| !fa4_keys.include?k}
      total_hash.merge!(fa4_hash){ |k, a_value, b_value| a_value.merge!(b_value){|k1, a1, b1| {"mark" => a1["mark"].to_f + b1["mark"].to_f,"grade" => a1["grade"]+b1["grade"]}}}
      total_hash.each{|k,v| v.each{|k1,v1| v1['mark']=(((v1['mark'].to_f)*100)/400).round(2);v1['grade']=GradingLevel.percentage_to_grade(v1['mark'], @batch_id).present? ? GradingLevel.percentage_to_grade(v1['mark'], @batch_id) : '-'}}
      @fa_score_hash=total_hash
    when "SA1+SA2"
      total_hash=Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
      total_hash.merge!(calculate_assessment_data('SA1'))
      sa1_keys=total_hash.collect{|k,v| k}
      sa2_hash=calculate_assessment_data('SA2')
      sa2_hash.reject!{|k,v| !sa1_keys.include?k}
      sa2_keys=sa2_hash.collect{|k,v| k}
      total_hash.reject!{|k,v| !sa2_keys.include?k}
      total_hash.merge!(sa2_hash){ |k, a_value, b_value| a_value.merge!(b_value){|k1, a1, b1| {"mark" => a1["mark"].to_f + b1["mark"].to_f,"grade" => a1["grade"]+b1["grade"]}}}
      total_hash.each{|k,v| v.each{|k1,v1| v1['mark']=(((v1['mark'].to_f)*100)/200).round(2);v1['grade']=GradingLevel.percentage_to_grade(v1['mark'], @batch_id).present? ? GradingLevel.percentage_to_grade(v1['mark'], @batch_id) : '-'}}
      @fa_score_hash=total_hash
    else
      return {}
    end
  end
  def calculate_assessment_data(assessment_group)
    hsh = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    fa_obtained_score_hash={}
    @batch=Batch.find @batch_id
    fa_groups=['FA1','FA2','FA3','FA4']
    @students=Student.search(:batch_id_equals=>@batch_id,:gender_like=>@gender,:student_category_id_equals=>@student_category_id)
    unless @students.nil?
      student_ids=@students.collect(&:id)
    end
    @subjects=@batch.subjects.active_and_has_exam
    grades=@batch.grading_level_list
    if fa_groups.include? assessment_group
      exams = []
      unless @exam_group_id.present?
        exams=Exam.find_all_by_subject_id_and_exam_group_id(@subjects.collect(&:id),@batch.exam_groups.collect(&:id),:include=>{:subject=>:fa_groups})
      else
        exams=Exam.find_all_by_exam_group_id(@exam_group_id,:include=>{:subject=>:fa_groups})
      end
      fa_group_ids=[]
      exams.each do |exam|
        fa_group=exam.subject.fa_groups.select{|s| s.name.split.last==assessment_group}.first
        unless fa_group.nil?
          fa_group_ids << fa_group.id
        end
      end
      exam_ids=exams.collect(&:id)
      @fa_score_hash={}
      CceReport.scholastic.all(:select=>"cce_reports.*,exams.subject_id,student_id,fa_criterias.fa_group_id,fa_criterias.max_marks as max_marks,fa_groups.criteria_formula as c_formula,fa_criterias.formula_key as c_key",:joins=>[{:fa_criteria=>:fa_group},:exam], :conditions=>{:student_id=>student_ids,:exam_id=>exam_ids,:fa_groups=>{:id=>fa_group_ids}}).group_by(&:student_id).each do |k,v|
        @fa_score_hash[k]={}
        v.group_by(&:subject_id).each do |k1,v1|
          v1.group_by(&:fa_group_id).each do |k2,v2|
            exam_id=v2.first.exam_id
            exam=Exam.find exam_id
            exam_cat_id=exam.exam_group.cce_exam_category_id
            wightage=CceWeightage.find_by_cce_exam_category_id_and_criteria_type(exam_cat_id,"FA").weightage
            fa_formula=v2.collect(&:c_formula).uniq.first
            if fa_formula.present?
              v2.group_by(&:c_key).each do |indicator,mark|
                hsh1={indicator=>(mark[0].grade_string.to_f)}
                fa_obtained_score_hash.merge!hsh1
              end
              assign_values=[]
              fa_obtained_score_hash.each{|fas,m| assign_values << "#{fas}=#{m}"}
              assign_values.each{|s| instance_eval(s.gsub("`",""))}
              fa_obtained_mark=begin
                instance_eval(fa_formula)
              rescue
                0
              end
              fa_max_score_hash={}
              v2.group_by(&:c_key).each do |indicator,mark|
                hsh1={indicator=>100.0}
                fa_max_score_hash.merge!hsh1
              end
              assign_values=[]
              fa_max_score_hash.each{|fas,m| assign_values << "#{fas}=#{m}"}
              assign_values.each{|s| instance_eval(s.gsub("`",""))}
              fa_max_mark=begin
                instance_eval(fa_formula)
              rescue
                1
              end
              grade_value=(fa_obtained_mark/fa_max_mark)*100
              grade=grades.to_a.find{|g| g.min_score <= grade_value.to_f.round(2).round}.try(:name) || "-"
              grade_mark= grade=="-"? "-" : grade_value.to_f.round(2)
              @fa_score_hash[k][k1]={'grade'=>grade , 'mark'=>grade_mark,'wightage'=>wightage}
            else
              grade_value = v1.count > 0 ? v1.sum{|e| e.grade_string.to_f}/v1.count: 0
              grade=grades.to_a.find{|g| g.min_score <= grade_value.to_f.round(2).round}.try(:name) || "-"
              grade_mark= grade=="-"? "-" : grade_value.to_f.round(2)
              @fa_score_hash[k][k1]={'grade'=>grade , 'mark'=>grade_mark,'wightage'=>wightage}
            end
          end
        end
      end
      return @fa_score_hash
    else
      if assessment_group=='SA1'
        @fa_score_hash={}
        cce=@batch.fa_groups.select{|s| s.name.split.last=="FA1" or s.name.split.last=="FA2"}
        unless cce.blank?
          cce_id=cce.first.cce_exam_category_id
          exam_group=@batch.exam_groups.find_by_cce_exam_category_id(cce_id)
          exams= Exam.find_all_by_subject_id_and_exam_group_id(@subjects.collect(&:id),exam_group.id)
          ExamScore.all(:select=>'exam_scores.*,student_id,subject_id,exams.maximum_marks',:conditions=>{:exam_id=>exams.collect(&:id)},:joins=>[:exam],:include=>:grading_level).group_by(&:student_id).each do |k,v|
            @fa_score_hash[k]={}
            v.group_by(&:subject_id).each do |k1,v1|


              #cce_weigtage

              exam_id=v1.first.exam_id
              exam=Exam.find exam_id
              exam_cat_id=exam.exam_group.cce_exam_category_id
              wightage=CceWeightage.find_by_cce_exam_category_id_and_criteria_type(exam_cat_id,"SA").weightage

              #cce_weigtages



              grade=v1.first.grading_level ? v1.first.grading_level.name : '-'
              grade_mark=v1[0].maximum_marks.to_f!=0?  grade=="-"? "-" : (v1[0].marks.to_f/v1 [0].maximum_marks.to_f)*100 : "-"

              grade_mark=grade_mark.round(2) unless grade_mark=="-"
              @fa_score_hash[k][k1]={'grade'=>grade , 'mark'=>grade_mark,'wightage'=>wightage}
            end
          end
        end
        return @fa_score_hash
      else
        @fa_score_hash={}
        cce=@batch.fa_groups.select{|s| s.name.split.last=="FA3" or s.name.split.last=="FA4"}
        unless cce.blank?
          cce_id=cce.first.cce_exam_category_id
          exam_group=@batch.exam_groups.find_by_cce_exam_category_id(cce_id)
          exams= Exam.find_all_by_subject_id_and_exam_group_id(@subjects.collect(&:id),exam_group.id)
          ExamScore.all(:select=>'exam_scores.*,student_id,subject_id,exams.maximum_marks',:conditions=>{:exam_id=>exams.collect(&:id)},:joins=>[:exam]).group_by(&:student_id).each do |k,v|
            @fa_score_hash[k]={}
            v.group_by(&:subject_id).each do |k1,v1|


              #cce_weigtage

              exam_id=v1.first.exam_id
              exam=Exam.find exam_id
              exam_cat_id=exam.exam_group.cce_exam_category_id
              wightage=CceWeightage.find_by_cce_exam_category_id_and_criteria_type(exam_cat_id,"SA").weightage

              #cce_weigtages

              grade=v1.first.grading_level ? v1.first.grading_level.name : '-'
              grade_mark=v1[0].maximum_marks.to_f!=0 ? grade=="-"? "-" : (v1[0].marks.to_f/v1[0].maximum_marks.to_f)*100 : "-"
              grade_mark=grade_mark.round(2) unless grade_mark=="-"
              @fa_score_hash[k][k1]={'grade'=>grade , 'mark'=>grade_mark,'wightage'=>wightage}
            end
          end
        end
        return @fa_score_hash
      end
    end
  end
  def avg(*args)
    count=args.length
    total=0
    args.each{|s| total+=s.to_f}
    return (total.to_f/count.to_f)
  end

  def best(*args)
    count=args[0]
    scores=args-args[0].to_a
    order=scores.sort_by{|d| d.to_f}.reverse
    values=order[0..(count-1)]
    total=0
    values.each{|s| total+=s.to_f}
    return total
  end

  def fetch_cbse_scholastic_data
    @fa_score_hash = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    fa_obtained_score_hash={}
    @batch=Batch.find @batch_id
    fa_groups=['FA1','FA2','FA3','FA4']
    @students=Student.search(:batch_id_equals=>@batch_id)
    unless @students.nil?
      student_ids=@students.collect(&:id)
    end
    grades=@batch.grading_level_list
    @exam_group=ExamGroup.find @exam_group_id
    @subject=Subject.find @subject_id
    @subject.fa_groups.all(:conditions=>{:cce_exam_category_id=>@exam_group.cce_exam_category_id}).each do |ag|
      if fa_groups.include? ag.name.split.last
        exams = []
        if @exam_group_id.nil?
          exams=Exam.find_all_by_subject_id_and_exam_group_id(@subject_id,@exam_group_id,:include=>{:subject=>:fa_groups})
        else
          exams=Exam.find_all_by_exam_group_id(@exam_group_id,:include=>{:subject=>:fa_groups})
        end
        fa_group_ids=[]
        exams.each do |exam|
          fa_group=exam.subject.fa_groups.select{|s| s.name.split.last==ag.name.split.last}.first
          unless fa_group.nil?
            fa_group_ids << fa_group.id
          end
        end
        exam_ids=exams.collect(&:id)
        CceReport.scholastic.all(:select=>"cce_reports.*,exams.subject_id,student_id,fa_criterias.fa_group_id,fa_criterias.max_marks as max_marks,fa_groups.criteria_formula as c_formula,fa_criterias.formula_key as c_key",:joins=>[{:fa_criteria=>:fa_group},:exam], :conditions=>{:student_id=>student_ids,:exam_id=>exam_ids,:fa_groups=>{:id=>fa_group_ids}}).group_by(&:student_id).each do |k,v|
          v.group_by(&:subject_id).each do |k1,v1|
            v1.group_by(&:fa_group_id).each do |k2,v2|
              fa_formula=v2.collect(&:c_formula).uniq.first
              if fa_formula.present?
                v2.group_by(&:c_key).each do |indicator,mark|
                  hsh1={indicator=>(mark[0].grade_string.to_f)}
                  fa_obtained_score_hash.merge!hsh1
                end
                assign_values=[]
                fa_obtained_score_hash.each{|fas,m| assign_values << "#{fas}=#{m}"}
                assign_values.each{|s| instance_eval(s.gsub("`",""))}
                fa_obtained_mark=begin
                  instance_eval(fa_formula)
                rescue
                  0
                end
                fa_max_score_hash={}
                v2.group_by(&:c_key).each do |indicator,mark|
                  hsh1={indicator=>100.0}
                  fa_max_score_hash.merge!hsh1
                end
                assign_values=[]
                fa_max_score_hash.each{|fas,m| assign_values << "#{fas}=#{m}"}
                assign_values.each{|s| instance_eval(s.gsub("`",""))}
                fa_max_mark=begin
                  instance_eval(fa_formula)
                rescue
                  1
                end
                grade_value=(fa_obtained_mark/fa_max_mark)*100
                grade=grades.to_a.find{|g| g.min_score <= grade_value.to_f.round(2).round}.try(:name) || "-"
                grade_mark= grade=="-"? "-" : grade_value.to_f.round(2)
                @fa_score_hash[k][k1][ag.name.split.last]={'grade'=>grade , 'mark'=>grade_mark}
              else
                grade_value = v1.count > 0 ? v1.sum{|e| e.grade_string.to_f}/v1.count: 0
                grade=grades.to_a.find{|g| g.min_score <= grade_value.to_f.round(2).round}.try(:name) || "-"
                grade_mark= grade=="-"? "-" : grade_value.to_f.round(2)
                @fa_score_hash[k][k1][ag.name.split.last]={'grade'=>grade , 'mark'=>grade_mark}
              end
            end
          end
        end
        if ag.name.split.last=="FA1" or ag.name.split.last=="FA2"
          cce=ag
          exams= Exam.find_all_by_subject_id_and_exam_group_id(@subject_id,@exam_group_id)
          ExamScore.all(:select=>'exam_scores.*,student_id,subject_id,exams.maximum_marks',:conditions=>{:exam_id=>exams.collect(&:id)},:joins=>[:exam],:include=>:grading_level).group_by(&:student_id).each do |k,v|
            v.group_by(&:subject_id).each do |k1,v1|
              grade=v1.first.grading_level ? v1.first.grading_level.name : '-'
              grade_mark=v1[0].maximum_marks.to_f!=0?  grade=="-"? "-" : (v1[0].marks.to_f/v1 [0].maximum_marks.to_f)*100 : "-"

              grade_mark=grade_mark.round(2) unless grade_mark=="-"
              @fa_score_hash[k][k1]["SA1"]={'grade'=>grade , 'mark'=>grade_mark}
            end
          end
        else
          cce=ag
          exams= Exam.find_all_by_subject_id_and_exam_group_id(@subject_id,@exam_group_id)
          ExamScore.all(:select=>'exam_scores.*,student_id,subject_id,exams.maximum_marks',:conditions=>{:exam_id=>exams.collect(&:id)},:joins=>[:exam]).group_by(&:student_id).each do |k,v|
            v.group_by(&:subject_id).each do |k1,v1|
              grade=v1.first.grading_level ? v1.first.grading_level.name : '-'
              grade_mark=v1[0].maximum_marks.to_f!=0 ? grade=="-"? "-" : (v1[0].marks.to_f/v1[0].maximum_marks.to_f)*100 : "-"
              grade_mark=grade_mark.round(2) unless grade_mark=="-"
              @fa_score_hash[k][k1]["SA2"]={'grade'=>grade , 'mark'=>grade_mark}
            end
          end
        end
      end
    end
  end
  def avg(*args)
    count=args.length
    total=0
    args.each{|s| total+=s.to_f}
    return (total.to_f/count.to_f)
  end

  def best(*args)
    count=args[0]
    scores=args-args[0].to_a
    order=scores.sort_by{|d| d.to_f}.reverse
    values=order[0..(count-1)]
    total=0
    values.each{|s| total+=s.to_f}
    return total
  end

  def fetch_cbse_co_scholastic_data
    @co_hash=Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    @batch.students.each do |s|
      s.cce_reports.coscholastic.all(:select=>"cce_reports.*,observations.observation_group_id,observations.name AS o_name, observations.sort_order,observation_groups.sort_order as s_order",:joins=>'INNER JOIN observations ON cce_reports.observable_id = observations.id INNER JOIN observation_groups on observation_groups.id=observations.observation_group_id', :conditions=>["batch_id=? and observation_groups.id=?", @batch.id,@observation_group_id], :order=>"observations.sort_order ASC").group_by(&:observation_group_id).each do |key,val|
        @co_hash[:ob_list] = []
        val.group_by(&:observable_id).each do |k,v|
          @co_hash[s.id][:observations][k][:grade] = v.find{|r| r.grade_string}.try(:grade_string)
          @co_hash[s.id][:observations][k][:observation_name] = v.find{|r| r.grade_string}.try(:o_name)
          @co_hash[s.id][:observations][k][:sort_order] = v.find{|r| r.grade_string}.try(:sort_order)
          @co_hash[:ob_list] << v.find{|r| r.grade_string}.try(:o_name)
        end
      end
    end
  end

  def fetch_subject_wise_report
    hsh = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    fa_obtained_score_hash={}
    @batch=Batch.find @batch_id
    @subject=Subject.find @subject_id
    fa_groups=@subject.fa_groups
    grades=@batch.grading_level_list
    exam_ids=Exam.find_all_by_subject_id(@subject_id).collect(&:id)
    if @subject.students.empty?
      @students=Student.search(:batch_id_equals=>@batch_id,:gender_like=>@gender,:student_category_id_equals=>@student_category_id)
    else
      @students= Student.send :with_scope,:find=>{:conditions=>{:students_subjects=>{:subject_id=>@subject_id}} ,:joins=>"INNER JOIN `students_subjects` ON `students`.id = `students_subjects`.student_id"} do Student.search(:batch_id_equals=>@batch_id,:gender_like=>@gender,:student_category_id_equals=>@student_category_id) end
    end
    unless @students.nil?
      student_ids=@students.collect(&:id)
    end
    @fa1=fa_groups.select{|s| s.name.split.last=='FA1'}.first ? fa_groups.select{|s| s.name.split.last=='FA1'}.first.id : 0
    @fa2=fa_groups.select{|s| s.name.split.last=='FA2'}.first ? fa_groups.select{|s| s.name.split.last=='FA2'}.first.id : 0
    @fa3=fa_groups.select{|s| s.name.split.last=='FA3'}.first ? fa_groups.select{|s| s.name.split.last=='FA3'}.first.id : 0
    @fa4=fa_groups.select{|s| s.name.split.last=='FA4'}.first ? fa_groups.select{|s| s.name.split.last=='FA4'}.first.id : 0
    @sa1=0
    @sa2=0
    cce=fa_groups.select{|s| s.name.split.last=="FA1" or s.name.split.last=="FA2"}
    unless cce.blank?
      cce_id=cce.first.cce_exam_category_id
      exam_group=@batch.exam_groups.find_by_cce_exam_category_id(cce_id)
      @sa1 = exam_group.present? ? exam_group.id : 0
    end
    cce=fa_groups.select{|s| s.name.split.last=="FA3" or s.name.split.last=="FA4"}
    unless cce.blank?
      cce_id=cce.first.cce_exam_category_id
      exam_group=@batch.exam_groups.find_by_cce_exam_category_id(cce_id)
      @sa2 = exam_group.present? ? exam_group.id : 0
    end
    fa_score_hash={}
    CceReport.scholastic.all(:select=>"cce_reports.*,exams.subject_id,student_id,fa_criterias.fa_group_id,fa_criterias.max_marks as max_marks,fa_groups.criteria_formula as c_formula,fa_criterias.formula_key as c_key",:joins=>[{:fa_criteria=>:fa_group},:exam], :conditions=>{:exam_id=>exam_ids,:student_id=>student_ids}).group_by(&:student_id).each do |k,v|
      fa_score_hash[k]={}
      v.group_by(&:fa_group_id).each do |k1,v1|
        fa_formula=v1.collect(&:c_formula).uniq.first
        if fa_formula.present?
          v1.group_by(&:c_key).each do |indicator,mark|
            hsh1={indicator=>(mark[0].grade_string.to_f)}
            fa_obtained_score_hash.merge!hsh1
          end
          assign_values=[]
          fa_obtained_score_hash.each{|fas,m| assign_values << "#{fas}=#{m}"}
          assign_values.each{|s| instance_eval(s.gsub("`",""))}
          fa_obtained_mark=begin
            instance_eval(fa_formula)
          rescue
            0
          end
          fa_max_score_hash={}
          v1.group_by(&:c_key).each do |indicator,mark|
            hsh1={indicator=>100.0}
            fa_max_score_hash.merge!hsh1
          end
          assign_values=[]
          fa_max_score_hash.each{|fas,m| assign_values << "#{fas}=#{m}"}
          assign_values.each{|s| instance_eval(s.gsub("`",""))}
          fa_max_mark=begin
            instance_eval(fa_formula)
          rescue
            1
          end
          grade_value=(fa_obtained_mark/fa_max_mark)*100
          grade=grades.to_a.find{|g| g.min_score <= grade_value.to_f.round(2).round}.try(:name) || "-"
          grade_mark= grade=="-"? "-" : grade_value.to_f.round(2)
          fa_score_hash[k][k1]={'grade'=>grade , 'mark'=>grade_mark}
        else
          grade_value = v1.count > 0 ? v1.sum{|e| e.grade_string.to_f}/v1.count: 0
          grade=grades.to_a.find{|g| g.min_score <= grade_value.to_f.round(2).round}.try(:name) || "-"
          grade_mark= grade=="-"? "-" : grade_value.to_f.round(2)
          fa_score_hash[k][k1]={'grade'=>grade , 'mark'=>grade_mark}
        end
      end
    end
    exam_score_hash={}
    ExamScore.all(:select=>'exam_scores.*,student_id,exam_group_id,exams.maximum_marks',:conditions=>{:exam_id=>exam_ids,:student_id=>student_ids},:joins=>[:exam],:include=>:grading_level).group_by(&:student_id).each do |k,v|
      exam_score_hash[k]={}
      v.group_by(&:exam_group_id).each do |k1,v1|
        grade=v1.first.grading_level ? v1.first.grading_level.name : '-'
        grade_mark=v1[0].maximum_marks.to_f!=0 ? grade=="-"? "-"  : (v1[0].marks.to_f/v1[0].maximum_marks.to_f)*100 :"-"
        grade_mark=grade_mark.round(2) unless grade_mark=="-"
        exam_score_hash[k][k1]={'grade'=>grade , 'mark'=>grade_mark}
      end
    end
    @score_hash=fa_score_hash.merge(exam_score_hash){|key,v1,v2| v1.merge(v2) }
  end

end
