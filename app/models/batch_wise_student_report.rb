class BatchWiseStudentReport < ActiveRecord::Base
  belongs_to :course
  serialize :parameters, Hash
  has_attached_file :report,
    :url => "/cce_reports/batch_wise_student_report_download/:id",
    :path => "uploads/:class/:attachment/:id_partition/:style/:basename.:extension",
    :max_file_size => 5242880,
    :permitted_file_types =>[]

  after_save :remove_excess_entry


  def remove_excess_entry
    if BatchWiseStudentReport.count>10
      BatchWiseStudentReport.first.destroy
    end
  end

  def perform
    @report=BatchWiseStudentReport.find(self.id)
    @report.update_attributes(:status => 'running')
    pdf_generation
    zip_file=File.open(@path+"/#{@course_code.gsub(/ /, '_')}_CCE_Reports.zip",'r')
    @report.report=zip_file
    @report.save
    @report.update_attribute('status','success')
  rescue Exception => e
    @report.update_attribute('status','failed')
  ensure
    puts "removing directory "+@path
    system('rm -rf '+@path)
  end
 
  def pdf_generation
    Authorization.current_user = User.first(:conditions=>{:admin=>true})
    @path="tmp/"+Time.now.to_i.to_s
    Batch.active.find_all_by_id(self.parameters[:batch_ids],:include=>:course).each do |batch|
      @course_code=batch.course.code
      system("mkdir "+@path)
      self.parameters[:report_type]=="cce_report" ? report = "cce_full_exam_report" : report = "student_report_pdf"
      opts = {}
      if report=='cce_full_exam_report'
        opts = {:header =>{:content=>nil},:margin=>{:left=>10,:right=>0,:top=>10,:bottom=>5}}
      end
      cce_pdf = PdfMaker.new('cce_reports',report,@path+"/"+batch.full_name)
      batch.students.active.all.each do |student|
        cce_pdf.generate_pdf("#{student.first_name}-#{student.admission_no}-CCE-Report",opts) do
          begin
            params = {:report_format_type=>'pdf',:type=>'regular'}
            params.merge!({:id=>student.id,:batch_id=>student.batch_id})
            @student=student
            @batch=@student.batch
            @exam_groups=@batch.exam_groups.all(:joins=>:cce_exam_category)
            @data_hash = CceReport.fetch_student_wise_report(params)
            @check_term="all"
            @grading_levels = GradingLevel.default
            @grade_sets=CceGradeSet.all
            fetch_attendance_data
            fetch_report
          rescue Exception=> e
            puts e.message
            puts e.backtrace
          end
        end
      end
    end
    system("cd "+@path+";zip -r "+@course_code.gsub(/ /, '_')+"_CCE_Reports.zip .")
  end
end