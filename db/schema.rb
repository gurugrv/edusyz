# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 201306240649272) do

  create_table "additional_charges", :force => true do |t|
    t.string   "name"
    t.decimal  "amount",       :precision => 15, :scale => 2
    t.integer  "invoice_id"
    t.string   "invoice_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "additional_charges", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "additional_exam_groups", :force => true do |t|
    t.string  "name"
    t.integer "batch_id"
    t.string  "exam_type"
    t.boolean "is_published",     :default => false
    t.boolean "result_published", :default => false
    t.string  "students_list"
    t.date    "exam_date"
  end

  create_table "additional_exam_scores", :force => true do |t|
    t.integer  "student_id"
    t.integer  "additional_exam_id"
    t.decimal  "marks",              :precision => 7, :scale => 2
    t.integer  "grading_level_id"
    t.string   "remarks"
    t.boolean  "is_failed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "additional_exams", :force => true do |t|
    t.integer  "additional_exam_group_id"
    t.integer  "subject_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "maximum_marks"
    t.integer  "minimum_marks"
    t.integer  "grading_level_id"
    t.integer  "weightage",                :default => 0
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "additional_field_options", :force => true do |t|
    t.integer  "additional_field_id"
    t.string   "field_option"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "additional_fields", :force => true do |t|
    t.string   "name"
    t.boolean  "status"
    t.boolean  "is_mandatory", :default => false
    t.string   "input_type"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "additional_report_csvs", :force => true do |t|
    t.string   "model_name"
    t.string   "method_name"
    t.text     "parameters"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "csv_report_file_name"
    t.string   "csv_report_content_type"
    t.integer  "csv_report_file_size"
    t.datetime "csv_report_updated_at"
  end

  create_table "allocated_classrooms", :force => true do |t|
    t.integer  "classroom_allocation_id"
    t.integer  "classroom_id"
    t.integer  "subject_id"
    t.integer  "timetable_entry_id"
    t.date     "date"
    t.boolean  "is_deleted",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "allocated_classrooms", ["timetable_entry_id", "subject_id", "classroom_allocation_id", "classroom_id"], :name => "index_by_fields", :limit => {"classroom_id"=>nil, "classroom_allocation_id"=>nil, "subject_id"=>nil, "timetable_entry_id"=>nil}

  create_table "allotment_log_details", :force => true do |t|
    t.string   "name"
    t.string   "registration_no"
    t.string   "status"
    t.string   "description"
    t.integer  "registration_course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_session_store", :force => true do |t|
    t.integer   "session_id_crc",               :null => false
    t.string    "session_id",     :limit => 32, :null => false
    t.timestamp "updated_at",                   :null => false
    t.text      "data"
  end

  add_index "app_session_store", ["session_id_crc", "session_id"], :name => "session_id", :unique => true, :limit => {"session_id"=>nil, "session_id_crc"=>nil}
  add_index "app_session_store", ["updated_at"], :name => "updated_at", :limit => {"updated_at"=>nil}

  create_table "applicant_additional_details", :force => true do |t|
    t.integer  "applicant_id"
    t.integer  "additional_field_id"
    t.string   "additional_info"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applicant_additional_details", ["additional_field_id"], :name => "by_additional_field_id", :limit => {"additional_field_id"=>nil}
  add_index "applicant_additional_details", ["applicant_id"], :name => "by_applicant_id", :limit => {"applicant_id"=>nil}
  add_index "applicant_additional_details", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "applicant_addl_attachments", :force => true do |t|
    t.integer  "school_id"
    t.integer  "applicant_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "attachment_updated_at"
  end

  add_index "applicant_addl_attachments", ["applicant_id"], :name => "index_applicant_addl_attachments_on_applicant_id", :limit => {"applicant_id"=>nil}
  add_index "applicant_addl_attachments", ["school_id"], :name => "index_applicant_addl_attachments_on_school_id", :limit => {"school_id"=>nil}

  create_table "applicant_addl_field_groups", :force => true do |t|
    t.integer  "school_id"
    t.integer  "registration_course_id"
    t.string   "name"
    t.boolean  "is_active",              :default => true
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applicant_addl_field_groups", ["is_active"], :name => "index_applicant_addl_field_groups_on_is_active", :limit => {"is_active"=>nil}
  add_index "applicant_addl_field_groups", ["registration_course_id"], :name => "index_applicant_addl_field_groups_on_registration_course_id", :limit => {"registration_course_id"=>nil}
  add_index "applicant_addl_field_groups", ["school_id"], :name => "index_applicant_addl_field_groups_on_school_id", :limit => {"school_id"=>nil}

  create_table "applicant_addl_field_values", :force => true do |t|
    t.integer  "school_id"
    t.integer  "applicant_addl_field_id"
    t.string   "option"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applicant_addl_field_values", ["applicant_addl_field_id"], :name => "index_applicant_addl_field_values_on_applicant_addl_field_id", :limit => {"applicant_addl_field_id"=>nil}
  add_index "applicant_addl_field_values", ["school_id"], :name => "index_applicant_addl_field_values_on_school_id", :limit => {"school_id"=>nil}

  create_table "applicant_addl_fields", :force => true do |t|
    t.integer  "school_id"
    t.integer  "applicant_addl_field_group_id"
    t.string   "field_name"
    t.string   "field_type"
    t.boolean  "is_active",                     :default => true
    t.integer  "position"
    t.boolean  "is_mandatory",                  :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applicant_addl_fields", ["applicant_addl_field_group_id"], :name => "index_applicant_addl_fields_on_applicant_addl_field_group_id", :limit => {"applicant_addl_field_group_id"=>nil}
  add_index "applicant_addl_fields", ["school_id"], :name => "index_applicant_addl_fields_on_school_id", :limit => {"school_id"=>nil}

  create_table "applicant_addl_values", :force => true do |t|
    t.integer  "school_id"
    t.integer  "applicant_id"
    t.integer  "applicant_addl_field_id"
    t.text     "option"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applicant_addl_values", ["applicant_addl_field_id"], :name => "index_applicant_addl_values_on_applicant_addl_field_id", :limit => {"applicant_addl_field_id"=>nil}
  add_index "applicant_addl_values", ["applicant_id"], :name => "index_applicant_addl_values_on_applicant_id", :limit => {"applicant_id"=>nil}
  add_index "applicant_addl_values", ["school_id"], :name => "index_applicant_addl_values_on_school_id", :limit => {"school_id"=>nil}

  create_table "applicant_guardians", :force => true do |t|
    t.integer  "school_id"
    t.integer  "applicant_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "relation"
    t.string   "email"
    t.string   "office_phone1"
    t.string   "office_phone2"
    t.string   "mobile_phone"
    t.string   "office_address_line1"
    t.string   "office_address_line2"
    t.string   "city"
    t.string   "state"
    t.integer  "country_id"
    t.date     "dob"
    t.string   "occupation"
    t.string   "income"
    t.string   "education"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applicant_guardians", ["applicant_id"], :name => "index_applicant_guardians_on_applicant_id", :limit => {"applicant_id"=>nil}
  add_index "applicant_guardians", ["school_id"], :name => "index_applicant_guardians_on_school_id", :limit => {"school_id"=>nil}

  create_table "applicant_previous_datas", :force => true do |t|
    t.integer  "school_id"
    t.integer  "applicant_id"
    t.string   "last_attended_school"
    t.string   "qualifying_exam"
    t.string   "qualifying_exam_year"
    t.string   "qualifying_exam_roll"
    t.string   "qualifying_exam_final_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applicant_previous_datas", ["applicant_id"], :name => "index_applicant_previous_datas_on_applicant_id", :limit => {"applicant_id"=>nil}
  add_index "applicant_previous_datas", ["school_id"], :name => "index_applicant_previous_datas_on_school_id", :limit => {"school_id"=>nil}

  create_table "applicant_registration_settings", :force => true do |t|
    t.integer  "school_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applicant_registration_settings", ["school_id"], :name => "index_applicant_registration_settings_on_school_id", :limit => {"school_id"=>nil}

  create_table "applicants", :force => true do |t|
    t.integer  "school_id"
    t.string   "reg_no"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.integer  "country_id"
    t.integer  "nationality_id"
    t.string   "pin_code"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.string   "gender"
    t.integer  "registration_course_id"
    t.integer  "photo_file_size"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.string   "status"
    t.boolean  "has_paid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "pin_number"
    t.string   "print_token"
    t.text     "subject_ids"
    t.boolean  "is_academically_cleared"
    t.boolean  "is_financially_cleared"
    t.decimal  "amount",                  :precision => 12, :scale => 2
    t.text     "normal_subject_ids"
    t.datetime "photo_updated_at"
  end

  add_index "applicants", ["created_at"], :name => "index_applicants_on_created_at", :limit => {"created_at"=>nil}
  add_index "applicants", ["school_id"], :name => "index_applicants_on_school_id", :limit => {"school_id"=>nil}
  add_index "applicants", ["status"], :name => "index_applicants_on_status", :limit => {"status"=>nil}

  create_table "apply_leaves", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "employee_leave_types_id"
    t.boolean  "is_half_day"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "reason"
    t.boolean  "approved",                :default => false
    t.boolean  "viewed_by_manager",       :default => false
    t.string   "manager_remark"
    t.integer  "approving_manager"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archived_employee_additional_details", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "additional_field_id"
    t.string   "additional_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archived_employee_bank_details", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "bank_field_id"
    t.string   "bank_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archived_employee_salary_structures", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "payroll_category_id"
    t.string   "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archived_employees", :force => true do |t|
    t.integer  "employee_category_id"
    t.string   "employee_number"
    t.date     "joining_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "job_title"
    t.integer  "employee_position_id"
    t.integer  "employee_department_id"
    t.integer  "reporting_manager_id"
    t.integer  "employee_grade_id"
    t.string   "qualification"
    t.text     "experience_detail"
    t.integer  "experience_year"
    t.integer  "experience_month"
    t.boolean  "status"
    t.string   "status_description"
    t.date     "date_of_birth"
    t.string   "marital_status"
    t.integer  "children_count"
    t.string   "father_name"
    t.string   "mother_name"
    t.string   "husband_name"
    t.string   "blood_group"
    t.integer  "nationality_id"
    t.string   "home_address_line1"
    t.string   "home_address_line2"
    t.string   "home_city"
    t.string   "home_state"
    t.integer  "home_country_id"
    t.string   "home_pin_code"
    t.string   "office_address_line1"
    t.string   "office_address_line2"
    t.string   "office_city"
    t.string   "office_state"
    t.integer  "office_country_id"
    t.string   "office_pin_code"
    t.string   "office_phone1"
    t.string   "office_phone2"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.string   "email"
    t.string   "fax"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.binary   "photo_data",             :limit => 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "photo_file_size"
    t.integer  "former_id"
    t.integer  "user_id"
    t.datetime "photo_updated_at"
    t.string   "library_card"
  end

  add_index "archived_employees", ["employee_department_id"], :name => "index_archived_employees_on_employee_department_id", :limit => {"employee_department_id"=>nil}
  add_index "archived_employees", ["employee_number"], :name => "employee_number_unique_index", :unique => true, :limit => {"employee_number"=>nil}
  add_index "archived_employees", ["former_id"], :name => "index_archived_employees_on_former_id", :limit => {"former_id"=>nil}

  create_table "archived_exam_scores", :force => true do |t|
    t.integer  "student_id"
    t.integer  "exam_id"
    t.decimal  "marks",            :precision => 7, :scale => 2
    t.integer  "grading_level_id"
    t.string   "remarks"
    t.boolean  "is_failed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "archived_exam_scores", ["student_id", "exam_id"], :name => "index_archived_exam_scores_on_student_id_and_exam_id", :limit => {"student_id"=>nil, "exam_id"=>nil}

  create_table "archived_guardians", :force => true do |t|
    t.integer  "ward_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "relation"
    t.string   "email"
    t.string   "office_phone1"
    t.string   "office_phone2"
    t.string   "mobile_phone"
    t.string   "office_address_line1"
    t.string   "office_address_line2"
    t.string   "city"
    t.string   "state"
    t.integer  "country_id"
    t.date     "dob"
    t.string   "occupation"
    t.string   "income"
    t.string   "education"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "former_user_id"
    t.integer  "former_id"
  end

  create_table "archived_students", :force => true do |t|
    t.string   "admission_no"
    t.string   "class_roll_no"
    t.date     "admission_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "batch_id"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "blood_group"
    t.string   "birth_place"
    t.integer  "nationality_id"
    t.string   "language"
    t.string   "religion"
    t.integer  "student_category_id"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "pin_code"
    t.integer  "country_id"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.binary   "photo_data",                     :limit => 16777215
    t.string   "status_description"
    t.boolean  "is_active",                                          :default => true
    t.boolean  "is_deleted",                                         :default => false
    t.integer  "immediate_contact_id"
    t.boolean  "is_sms_enabled",                                     :default => true
    t.integer  "former_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "photo_file_size"
    t.integer  "user_id"
    t.boolean  "is_email_enabled",                                   :default => true
    t.integer  "sibling_id"
    t.datetime "photo_updated_at"
    t.date     "date_of_leaving"
    t.boolean  "former_has_paid_fees"
    t.string   "roll_number"
    t.boolean  "former_has_paid_fees_for_batch"
    t.string   "library_card"
  end

  add_index "archived_students", ["admission_no"], :name => "admission_no_unique_index", :unique => true, :limit => {"admission_no"=>nil}
  add_index "archived_students", ["batch_id"], :name => "index_archived_students_on_batch_id", :limit => {"batch_id"=>nil}
  add_index "archived_students", ["former_id"], :name => "index_archived_students_on_former_id", :limit => {"former_id"=>nil}

  create_table "assessment_scores", :force => true do |t|
    t.integer  "student_id"
    t.float    "grade_points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exam_id"
    t.integer  "batch_id"
    t.integer  "descriptive_indicator_id"
  end

  add_index "assessment_scores", ["student_id", "batch_id", "descriptive_indicator_id", "exam_id"], :name => "score_index", :limit => {"descriptive_indicator_id"=>nil, "batch_id"=>nil, "student_id"=>nil, "exam_id"=>nil}

  create_table "asset_entries", :force => true do |t|
    t.text     "dynamic_attributes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_asset_id"
    t.integer  "school_id"
  end

  add_index "asset_entries", ["school_id"], :name => "index_asset_entries_on_school_id", :limit => {"school_id"=>nil}

  create_table "asset_field_options", :force => true do |t|
    t.integer  "asset_field_id"
    t.string   "option"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "asset_field_options", ["school_id"], :name => "index_asset_field_options_on_school_id", :limit => {"school_id"=>nil}

  create_table "asset_fields", :force => true do |t|
    t.integer  "school_asset_id"
    t.string   "field_name"
    t.string   "field_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "asset_fields", ["school_id"], :name => "index_asset_fields_on_school_id", :limit => {"school_id"=>nil}

  create_table "assets", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "amount",      :precision => 15, :scale => 4
    t.boolean  "is_inactive",                                :default => false
    t.boolean  "is_deleted",                                 :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignment_answers", :force => true do |t|
    t.integer  "assignment_id"
    t.integer  "student_id"
    t.string   "status",                  :default => "0"
    t.string   "title"
    t.text     "content"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "assignment_answers", ["school_id"], :name => "index_assignment_answers_on_school_id", :limit => {"school_id"=>nil}

  create_table "assignments", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "subject_id"
    t.text     "student_list"
    t.string   "title"
    t.text     "content"
    t.datetime "duedate"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "assignments", ["school_id"], :name => "index_assignments_on_school_id", :limit => {"school_id"=>nil}

  create_table "attendance_weekday_sets", :force => true do |t|
    t.integer  "batch_id"
    t.integer  "weekday_set_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendances", :force => true do |t|
    t.integer  "student_id"
    t.integer  "period_table_entry_id"
    t.boolean  "forenoon",              :default => false
    t.boolean  "afternoon",             :default => false
    t.string   "reason"
    t.date     "month_date"
    t.integer  "batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendances", ["month_date", "batch_id"], :name => "index_attendances_on_month_date_and_batch_id", :limit => {"batch_id"=>nil, "month_date"=>nil}
  add_index "attendances", ["student_id", "batch_id"], :name => "index_attendances_on_student_id_and_batch_id", :limit => {"batch_id"=>nil, "student_id"=>nil}

  create_table "bank_fields", :force => true do |t|
    t.string   "name"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batch_class_timing_sets", :force => true do |t|
    t.integer  "batch_id"
    t.integer  "class_timing_set_id"
    t.integer  "weekday_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "batch_class_timing_sets", ["batch_id", "class_timing_set_id", "weekday_id"], :name => "bctw_index", :limit => {"weekday_id"=>nil, "batch_id"=>nil, "class_timing_set_id"=>nil}
  add_index "batch_class_timing_sets", ["batch_id"], :name => "index_batch_class_timing_sets_on_batch_id", :limit => {"batch_id"=>nil}
  add_index "batch_class_timing_sets", ["class_timing_set_id"], :name => "index_batch_class_timing_sets_on_class_timing_set_id", :limit => {"class_timing_set_id"=>nil}

  create_table "batch_events", :force => true do |t|
    t.integer  "event_id"
    t.integer  "batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "batch_events", ["batch_id"], :name => "index_batch_events_on_batch_id", :limit => {"batch_id"=>nil}

  create_table "batch_groups", :force => true do |t|
    t.integer  "course_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batch_students", :force => true do |t|
    t.integer  "student_id"
    t.integer  "batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roll_number"
  end

  add_index "batch_students", ["batch_id", "student_id"], :name => "index_batch_students_on_batch_id_and_student_id", :limit => {"batch_id"=>nil, "student_id"=>nil}
  add_index "batch_students", ["student_id"], :name => "index_batch_students_on_student_id", :limit => {"student_id"=>nil}

  create_table "batch_tutors", :id => false, :force => true do |t|
    t.integer "employee_id"
    t.integer "batch_id"
  end

  add_index "batch_tutors", ["employee_id", "batch_id"], :name => "index_batch_tutors_on_employee_id_and_batch_id", :limit => {"batch_id"=>nil, "employee_id"=>nil}

  create_table "batch_wise_student_reports", :force => true do |t|
    t.string   "status"
    t.text     "parameters"
    t.string   "report_file_name"
    t.string   "report_content_type"
    t.integer  "report_file_size"
    t.datetime "report_updated_at"
    t.integer  "course_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batches", :force => true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "is_active",           :default => true
    t.boolean  "is_deleted",          :default => false
    t.string   "employee_id"
    t.integer  "weekday_set_id"
    t.integer  "class_timing_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roll_number_prefix"
  end

  add_index "batches", ["course_id"], :name => "index_batches_on_course_id", :limit => {"course_id"=>nil}
  add_index "batches", ["is_active"], :name => "index_batches_on_is_active", :limit => {"is_active"=>nil}
  add_index "batches", ["is_deleted", "is_active", "course_id", "name"], :name => "index_batches_on_is_deleted_and_is_active_and_course_id_and_name", :limit => {"course_id"=>nil, "name"=>nil, "is_active"=>nil, "is_deleted"=>nil}
  add_index "batches", ["is_deleted"], :name => "index_batches_on_is_deleted", :limit => {"is_deleted"=>nil}

  create_table "biometric_informations", :force => true do |t|
    t.integer  "user_id"
    t.string   "biometric_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_comments", :force => true do |t|
    t.text     "body"
    t.boolean  "is_deleted"
    t.integer  "user_id"
    t.integer  "blog_post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "blog_comments", ["blog_post_id"], :name => "by_blog_post_id", :limit => {"blog_post_id"=>nil}
  add_index "blog_comments", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "blog_posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "is_active"
    t.boolean  "is_published"
    t.boolean  "is_deleted"
    t.integer  "blog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "blog_posts", ["blog_id"], :name => "by_blog_id", :limit => {"blog_id"=>nil}
  add_index "blog_posts", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "blogs", :force => true do |t|
    t.string   "name"
    t.boolean  "is_active"
    t.boolean  "is_published"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "blogs", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "book_additional_details", :force => true do |t|
    t.integer  "book_id"
    t.integer  "book_additional_field_id"
    t.string   "additional_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "book_additional_details", ["school_id"], :name => "index_book_additional_details_on_school_id", :limit => {"school_id"=>nil}

  create_table "book_additional_field_options", :force => true do |t|
    t.string   "field_option"
    t.integer  "book_additional_field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "book_additional_field_options", ["school_id"], :name => "index_book_additional_field_options_on_school_id", :limit => {"school_id"=>nil}

  create_table "book_additional_fields", :force => true do |t|
    t.string   "name"
    t.boolean  "is_mandatory"
    t.string   "input_type"
    t.integer  "priority"
    t.boolean  "is_active"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "book_additional_fields", ["school_id"], :name => "index_book_additional_fields_on_school_id", :limit => {"school_id"=>nil}

  create_table "book_movements", :force => true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.date     "issue_date"
    t.date     "due_date"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "book_movements", ["school_id"], :name => "index_book_movements_on_school_id", :limit => {"school_id"=>nil}

  create_table "book_reservations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "reserved_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "book_reservations", ["school_id"], :name => "index_book_reservations_on_school_id", :limit => {"school_id"=>nil}

  create_table "books", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "book_number"
    t.integer  "book_movement_id"
    t.string   "status",           :default => "Available"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.string   "barcode"
  end

  add_index "books", ["barcode"], :name => "index_books_on_barcode", :limit => {"barcode"=>nil}
  add_index "books", ["school_id"], :name => "index_books_on_school_id", :limit => {"school_id"=>nil}

  create_table "buildings", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_deleted"
  end

  create_table "cancelled_finance_transactions", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.decimal  "amount",                 :precision => 15, :scale => 4
    t.boolean  "fine_included",                                         :default => false
    t.integer  "category_id"
    t.integer  "student_id"
    t.integer  "finance_fees_id"
    t.date     "transaction_date"
    t.decimal  "fine_amount",            :precision => 10, :scale => 4, :default => 0.0
    t.integer  "master_transaction_id",                                 :default => 0
    t.integer  "finance_id"
    t.string   "finance_type"
    t.integer  "payee_id"
    t.string   "payee_type"
    t.string   "receipt_no"
    t.string   "voucher_no"
    t.integer  "lastvchid"
    t.string   "payment_mode"
    t.text     "payment_note"
    t.integer  "user_id"
    t.string   "collection_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "batch_id"
    t.decimal  "auto_fine",              :precision => 15, :scale => 4
    t.text     "other_details"
    t.integer  "finance_transaction_id"
    t.string   "reference_no"
    t.string   "trans_type"
  end

  create_table "category_batches", :force => true do |t|
    t.integer  "finance_fee_category_id"
    t.integer  "batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_batches", ["finance_fee_category_id", "batch_id"], :name => "index_category_batches_on_finance_fee_category_id_and_batch_id", :limit => {"finance_fee_category_id"=>nil, "batch_id"=>nil}

  create_table "cce_exam_categories", :force => true do |t|
    t.string   "name"
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cce_grade_sets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cce_grades", :force => true do |t|
    t.string   "name"
    t.float    "grade_point"
    t.integer  "cce_grade_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cce_grades", ["cce_grade_set_id"], :name => "index_cce_grades_on_cce_grade_set_id", :limit => {"cce_grade_set_id"=>nil}

  create_table "cce_reports", :force => true do |t|
    t.integer  "observable_id"
    t.string   "observable_type"
    t.integer  "student_id"
    t.integer  "batch_id"
    t.string   "grade_string"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exam_id"
  end

  add_index "cce_reports", ["observable_id", "student_id", "batch_id", "exam_id", "observable_type"], :name => "cce_report_join_index", :limit => {"observable_type"=>nil, "batch_id"=>nil, "student_id"=>nil, "observable_id"=>nil, "exam_id"=>nil}

  create_table "cce_weightages", :force => true do |t|
    t.integer  "weightage"
    t.string   "criteria_type"
    t.integer  "cce_exam_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cce_weightages_courses", :id => false, :force => true do |t|
    t.integer "cce_weightage_id"
    t.integer "course_id"
  end

  add_index "cce_weightages_courses", ["cce_weightage_id"], :name => "index_cce_weightages_courses_on_cce_weightage_id", :limit => {"cce_weightage_id"=>nil}
  add_index "cce_weightages_courses", ["course_id", "cce_weightage_id"], :name => "index_for_join_table_cce_weightage_courses", :limit => {"course_id"=>nil, "cce_weightage_id"=>nil}
  add_index "cce_weightages_courses", ["course_id"], :name => "index_cce_weightages_courses_on_course_id", :limit => {"course_id"=>nil}

  create_table "class_designations", :force => true do |t|
    t.string   "name",                                      :null => false
    t.decimal  "cgpa",       :precision => 15, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "marks",      :precision => 15, :scale => 2
    t.integer  "course_id"
  end

  create_table "class_timing_sets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "class_timing_sets_class_timings", :force => true do |t|
    t.integer  "class_timing_set_id"
    t.integer  "class_timing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "class_timings", :force => true do |t|
    t.integer  "batch_id"
    t.string   "name"
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "is_break"
    t.boolean  "is_deleted",          :default => false
    t.integer  "class_timing_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "class_timings", ["batch_id", "start_time", "end_time"], :name => "index_class_timings_on_batch_id_and_start_time_and_end_time", :limit => {"start_time"=>nil, "batch_id"=>nil, "end_time"=>nil}
  add_index "class_timings", ["class_timing_set_id"], :name => "index_class_timings_on_class_timing_set_id", :limit => {"class_timing_set_id"=>nil}

  create_table "classroom_allocations", :force => true do |t|
    t.string   "allocation_type"
    t.integer  "timetable_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "classroom_allocations", ["timetable_id"], :name => "index_classroom_allocations_on_timetable_id", :limit => {"timetable_id"=>nil}

  create_table "classrooms", :force => true do |t|
    t.string   "name"
    t.integer  "building_id"
    t.integer  "capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_deleted"
  end

  add_index "classrooms", ["building_id"], :name => "index_classrooms_on_building_id", :limit => {"building_id"=>nil}

  create_table "collection_discounts", :force => true do |t|
    t.integer  "finance_fee_collection_id"
    t.integer  "fee_discount_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collection_discounts", ["finance_fee_collection_id", "fee_discount_id"], :name => "fee_discount_index", :limit => {"fee_discount_id"=>nil, "finance_fee_collection_id"=>nil}

  create_table "collection_particulars", :force => true do |t|
    t.integer  "finance_fee_collection_id"
    t.integer  "finance_fee_particular_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collection_particulars", ["finance_fee_collection_id", "finance_fee_particular_id"], :name => "fee_particular_index", :limit => {"finance_fee_particular_id"=>nil, "finance_fee_collection_id"=>nil}

  create_table "configurations", :force => true do |t|
    t.string   "config_key"
    t.string   "config_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "configurations", ["config_key"], :name => "index_configurations_on_config_key", :limit => {"config_key"=>"10"}
  add_index "configurations", ["config_value"], :name => "index_configurations_on_config_value", :limit => {"config_value"=>"10"}

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "regional_name"
  end

  create_table "course_pins", :force => true do |t|
    t.boolean  "is_pin_enabled"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  create_table "courses", :force => true do |t|
    t.string   "course_name"
    t.string   "code"
    t.string   "section_name"
    t.boolean  "is_deleted",                        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "grading_type"
    t.boolean  "enable_student_elective_selection", :default => false
    t.string   "roll_number_prefix"
  end

  add_index "courses", ["grading_type"], :name => "index_courses_on_grading_type", :limit => {"grading_type"=>nil}
  add_index "courses", ["is_deleted"], :name => "index_courses_on_is_deleted", :limit => {"is_deleted"=>nil}

  create_table "courses_observation_groups", :id => false, :force => true do |t|
    t.integer "course_id"
    t.integer "observation_group_id"
  end

  add_index "courses_observation_groups", ["course_id"], :name => "index_courses_observation_groups_on_course_id", :limit => {"course_id"=>nil}
  add_index "courses_observation_groups", ["observation_group_id"], :name => "index_courses_observation_groups_on_observation_group_id", :limit => {"observation_group_id"=>nil}

  create_table "custom_gateways", :force => true do |t|
    t.string   "name"
    t.text     "gateway_parameters"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_deleted",         :default => false
  end

  create_table "data_exports", :force => true do |t|
    t.integer  "export_structure_id"
    t.string   "file_format"
    t.string   "status"
    t.string   "export_file_file_name"
    t.string   "export_file_content_type"
    t.integer  "export_file_file_size"
    t.datetime "export_file_updated_at"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["locked_by"], :name => "index_delayed_jobs_on_locked_by", :limit => {"locked_by"=>nil}

  create_table "descriptive_indicators", :force => true do |t|
    t.string   "name"
    t.string   "desc"
    t.integer  "describable_id"
    t.string   "describable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_order"
    t.boolean  "show_in_report",   :default => false
  end

  add_index "descriptive_indicators", ["describable_id", "describable_type", "sort_order"], :name => "describable_index", :limit => {"describable_type"=>nil, "sort_order"=>nil, "describable_id"=>nil}

  create_table "discipline_actions", :force => true do |t|
    t.text     "body"
    t.string   "remarks"
    t.integer  "school_id"
    t.integer  "user_id"
    t.integer  "discipline_complaint_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discipline_actions", ["school_id"], :name => "index_discipline_actions_on_school_id", :limit => {"school_id"=>nil}
  add_index "discipline_actions", ["user_id"], :name => "index_discipline_actions_on_user_id", :limit => {"user_id"=>nil}

  create_table "discipline_attachments", :force => true do |t|
    t.integer  "school_id"
    t.integer  "discipline_participation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "discipline_comments", :force => true do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "school_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discipline_comments", ["school_id"], :name => "index_discipline_comments_on_school_id", :limit => {"school_id"=>nil}
  add_index "discipline_comments", ["user_id"], :name => "index_discipline_comments_on_user_id", :limit => {"user_id"=>nil}

  create_table "discipline_complaints", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.date     "trial_date"
    t.integer  "school_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "complaint_no"
    t.boolean  "action_taken", :default => false
  end

  add_index "discipline_complaints", ["school_id"], :name => "index_discipline_complaints_on_school_id", :limit => {"school_id"=>nil}
  add_index "discipline_complaints", ["user_id"], :name => "index_discipline_complaints_on_user_id", :limit => {"user_id"=>nil}

  create_table "discipline_participations", :force => true do |t|
    t.string   "type"
    t.boolean  "action_taken"
    t.integer  "school_id"
    t.integer  "user_id"
    t.integer  "discipline_complaint_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discipline_participations", ["school_id"], :name => "index_discipline_participations_on_school_id", :limit => {"school_id"=>nil}
  add_index "discipline_participations", ["user_id", "discipline_complaint_id", "type"], :name => "by_user_and_complaint", :limit => {"discipline_complaint_id"=>nil, "type"=>nil, "user_id"=>nil}

  create_table "discipline_student_actions", :force => true do |t|
    t.integer  "discipline_action_id"
    t.integer  "discipline_participation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discipline_student_actions", ["discipline_participation_id", "discipline_action_id"], :name => "by_action_and_participation", :limit => {"discipline_participation_id"=>nil, "discipline_action_id"=>nil}

  create_table "discount_particular_logs", :force => true do |t|
    t.boolean  "is_amount"
    t.string   "receiver_type"
    t.integer  "finance_fee_id"
    t.integer  "user_id"
    t.string   "name"
    t.decimal  "amount",         :precision => 15, :scale => 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discounts", :force => true do |t|
    t.string   "name"
    t.decimal  "amount",       :precision => 15, :scale => 2
    t.integer  "invoice_id"
    t.string   "invoice_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "discounts", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "donation_additional_details", :force => true do |t|
    t.integer  "finance_donation_id"
    t.integer  "additional_field_id"
    t.string   "additional_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donation_additional_field_options", :force => true do |t|
    t.integer  "donation_additional_field_id"
    t.string   "field_option"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donation_additional_fields", :force => true do |t|
    t.string   "name"
    t.boolean  "status"
    t.boolean  "is_mandatory"
    t.string   "input_type"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elective_groups", :force => true do |t|
    t.string   "name"
    t.integer  "batch_id"
    t.boolean  "is_deleted", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "end_date"
  end

  create_table "electives", :force => true do |t|
    t.integer  "elective_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_alerts", :force => true do |t|
    t.string   "model_name"
    t.boolean  "value"
    t.string   "mail_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  create_table "email_subscriptions", :force => true do |t|
    t.integer  "student_id"
    t.string   "name"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_additional_details", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "additional_field_id"
    t.string   "additional_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_attendances", :force => true do |t|
    t.date     "attendance_date"
    t.integer  "employee_id"
    t.integer  "employee_leave_type_id"
    t.string   "reason"
    t.boolean  "is_half_day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_bank_details", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "bank_field_id"
    t.string   "bank_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_categories", :force => true do |t|
    t.string   "name"
    t.string   "prefix"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_department_events", :force => true do |t|
    t.integer  "event_id"
    t.integer  "employee_department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employee_department_events", ["employee_department_id"], :name => "index_employee_department_events_on_employee_department_id", :limit => {"employee_department_id"=>nil}

  create_table "employee_departments", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_grades", :force => true do |t|
    t.string   "name"
    t.integer  "priority"
    t.boolean  "status"
    t.integer  "max_hours_day"
    t.integer  "max_hours_week"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_leave_types", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.boolean  "status"
    t.string   "max_leave_count"
    t.boolean  "carry_forward",   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_leaves", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "employee_leave_type_id"
    t.decimal  "leave_count",            :precision => 5, :scale => 1, :default => 0.0
    t.decimal  "leave_taken",            :precision => 5, :scale => 1, :default => 0.0
    t.datetime "reset_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employee_leaves", ["employee_id"], :name => "index_employee_leaves_on_employee_id", :limit => {"employee_id"=>nil}

  create_table "employee_positions", :force => true do |t|
    t.string   "name"
    t.integer  "employee_category_id"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_salary_structures", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "payroll_category_id"
    t.string   "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.integer  "employee_category_id"
    t.string   "employee_number"
    t.date     "joining_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "job_title"
    t.integer  "employee_position_id"
    t.integer  "employee_department_id"
    t.integer  "reporting_manager_id"
    t.integer  "employee_grade_id"
    t.string   "qualification"
    t.text     "experience_detail"
    t.integer  "experience_year"
    t.integer  "experience_month"
    t.boolean  "status"
    t.string   "status_description"
    t.date     "date_of_birth"
    t.string   "marital_status"
    t.integer  "children_count"
    t.string   "father_name"
    t.string   "mother_name"
    t.string   "husband_name"
    t.string   "blood_group"
    t.integer  "nationality_id"
    t.string   "home_address_line1"
    t.string   "home_address_line2"
    t.string   "home_city"
    t.string   "home_state"
    t.integer  "home_country_id"
    t.string   "home_pin_code"
    t.string   "office_address_line1"
    t.string   "office_address_line2"
    t.string   "office_city"
    t.string   "office_state"
    t.integer  "office_country_id"
    t.string   "office_pin_code"
    t.string   "office_phone1"
    t.string   "office_phone2"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.string   "email"
    t.string   "fax"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.binary   "photo_data",             :limit => 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "photo_file_size"
    t.integer  "user_id"
    t.datetime "photo_updated_at"
    t.string   "library_card"
  end

  add_index "employees", ["employee_department_id"], :name => "index_employees_on_employee_department_id", :limit => {"employee_department_id"=>nil}
  add_index "employees", ["employee_number"], :name => "employee_number_unique_index", :unique => true, :limit => {"employee_number"=>nil}
  add_index "employees", ["employee_number"], :name => "index_employees_on_employee_number", :limit => {"employee_number"=>"10"}
  add_index "employees", ["user_id"], :name => "index_employees_on_user_id", :limit => {"user_id"=>nil}

  create_table "employees_subjects", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employees_subjects", ["subject_id"], :name => "index_employees_subjects_on_subject_id", :limit => {"subject_id"=>nil}

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "is_common",   :default => false
    t.boolean  "is_holiday",  :default => false
    t.boolean  "is_exam",     :default => false
    t.boolean  "is_due",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "origin_id"
    t.string   "origin_type"
  end

  add_index "events", ["is_common", "is_holiday", "is_exam"], :name => "index_events_on_is_common_and_is_holiday_and_is_exam", :limit => {"is_common"=>nil, "is_exam"=>nil, "is_holiday"=>nil}
  add_index "events", ["origin_id", "origin_type"], :name => "polymorphic_origin_index", :limit => {"origin_type"=>nil, "origin_id"=>nil}

  create_table "exam_groups", :force => true do |t|
    t.string   "name"
    t.integer  "batch_id"
    t.string   "exam_type"
    t.boolean  "is_published",          :default => false
    t.boolean  "result_published",      :default => false
    t.date     "exam_date"
    t.boolean  "is_final_exam",         :default => false, :null => false
    t.integer  "cce_exam_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "icse_exam_category_id"
  end

  add_index "exam_groups", ["icse_exam_category_id"], :name => "index_exam_groups_on_icse_exam_category_id", :limit => {"icse_exam_category_id"=>nil}

  create_table "exam_scores", :force => true do |t|
    t.integer  "student_id"
    t.integer  "exam_id"
    t.decimal  "marks",            :precision => 7, :scale => 2
    t.integer  "grading_level_id"
    t.string   "remarks"
    t.boolean  "is_failed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exam_scores", ["exam_id", "student_id"], :name => "exam_scores_unique_index", :unique => true, :limit => {"student_id"=>nil, "exam_id"=>nil}
  add_index "exam_scores", ["student_id", "exam_id"], :name => "index_exam_scores_on_student_id_and_exam_id", :limit => {"student_id"=>nil, "exam_id"=>nil}

  create_table "exams", :force => true do |t|
    t.integer  "exam_group_id"
    t.integer  "subject_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.decimal  "maximum_marks",    :precision => 10, :scale => 2
    t.decimal  "minimum_marks",    :precision => 10, :scale => 2
    t.integer  "grading_level_id"
    t.integer  "weightage",                                       :default => 0
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exams", ["exam_group_id", "subject_id"], :name => "index_exams_on_exam_group_id_and_subject_id", :limit => {"exam_group_id"=>nil, "subject_id"=>nil}

  create_table "export_structures", :force => true do |t|
    t.string   "model_name"
    t.text     "query"
    t.string   "template"
    t.string   "plugin_name"
    t.text     "csv_header_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exports", :force => true do |t|
    t.text     "structure"
    t.string   "name"
    t.string   "model"
    t.text     "associated_columns"
    t.text     "join_columns"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "exports", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "fa_criterias", :force => true do |t|
    t.string   "fa_name"
    t.string   "desc"
    t.integer  "fa_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_order"
    t.boolean  "is_deleted",  :default => false
    t.float    "max_marks",   :default => 100.0
    t.string   "formula_key"
  end

  add_index "fa_criterias", ["fa_group_id"], :name => "index_fa_criterias_on_fa_group_id", :limit => {"fa_group_id"=>nil}

  create_table "fa_groups", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "cce_exam_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cce_grade_set_id"
    t.float    "max_marks",            :default => 100.0
    t.boolean  "is_deleted",           :default => false
    t.integer  "di_formula"
    t.string   "criteria_formula"
  end

  create_table "fa_groups_subjects", :id => false, :force => true do |t|
    t.integer "subject_id"
    t.integer "fa_group_id"
  end

  add_index "fa_groups_subjects", ["fa_group_id", "subject_id"], :name => "score_index", :limit => {"fa_group_id"=>nil, "subject_id"=>nil}
  add_index "fa_groups_subjects", ["fa_group_id"], :name => "index_fa_groups_subjects_on_fa_group_id", :limit => {"fa_group_id"=>nil}
  add_index "fa_groups_subjects", ["subject_id"], :name => "index_fa_groups_subjects_on_subject_id", :limit => {"subject_id"=>nil}

  create_table "features", :force => true do |t|
    t.string   "feature_key"
    t.boolean  "is_enabled",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fee_collection_batches", :force => true do |t|
    t.integer  "finance_fee_collection_id"
    t.integer  "batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fee_collection_batches", ["batch_id"], :name => "index_fee_collection_batches_on_batch_id", :limit => {"batch_id"=>nil}
  add_index "fee_collection_batches", ["finance_fee_collection_id"], :name => "index_fee_collection_batches_on_finance_fee_collection_id", :limit => {"finance_fee_collection_id"=>nil}

  create_table "fee_collection_discounts", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.integer  "receiver_id"
    t.integer  "finance_fee_collection_id"
    t.decimal  "discount",                  :precision => 15, :scale => 4
    t.boolean  "is_amount",                                                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fee_collection_particulars", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "amount",                    :precision => 12, :scale => 4
    t.integer  "finance_fee_collection_id"
    t.integer  "student_category_id"
    t.string   "admission_no"
    t.integer  "student_id"
    t.boolean  "is_deleted",                                               :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fee_discounts", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.integer  "receiver_id"
    t.integer  "finance_fee_category_id"
    t.decimal  "discount",                :precision => 15, :scale => 4
    t.boolean  "is_amount",                                              :default => false
    t.string   "receiver_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "batch_id"
    t.boolean  "is_deleted",                                             :default => false
    t.string   "master_receiver_type"
    t.integer  "master_receiver_id"
    t.boolean  "is_instant",                                             :default => false
  end

  add_index "fee_discounts", ["finance_fee_category_id"], :name => "index_fee_discounts_on_finance_fee_category_id", :limit => {"finance_fee_category_id"=>nil}

  create_table "fee_refunds", :force => true do |t|
    t.integer  "finance_fee_id"
    t.text     "reason"
    t.decimal  "amount",                 :precision => 15, :scale => 4
    t.integer  "finance_transaction_id"
    t.integer  "refund_rule_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fee_transactions", :force => true do |t|
    t.integer  "finance_fee_id"
    t.integer  "finance_transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fee_transactions", ["finance_fee_id", "finance_transaction_id"], :name => "finance_transaction_index", :limit => {"finance_fee_id"=>nil, "finance_transaction_id"=>nil}

  create_table "finance_donations", :force => true do |t|
    t.string   "donor"
    t.string   "description"
    t.decimal  "amount",           :precision => 15, :scale => 4
    t.integer  "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "transaction_date"
  end

  create_table "finance_fee_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "batch_id"
    t.boolean  "is_deleted",  :default => false, :null => false
    t.boolean  "is_master",   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "finance_fee_collections", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "due_date"
    t.integer  "fee_category_id"
    t.integer  "batch_id"
    t.boolean  "is_deleted",      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fine_id"
  end

  add_index "finance_fee_collections", ["batch_id"], :name => "index_finance_fee_collections_on_batch_id", :limit => {"batch_id"=>nil}
  add_index "finance_fee_collections", ["due_date"], :name => "index_finance_fee_collections_on_due_date", :limit => {"due_date"=>nil}
  add_index "finance_fee_collections", ["fee_category_id"], :name => "index_finance_fee_collections_on_fee_category_id", :limit => {"fee_category_id"=>nil}
  add_index "finance_fee_collections", ["is_deleted", "due_date"], :name => "is_deleted_and_due_date", :limit => {"due_date"=>nil, "is_deleted"=>nil}
  add_index "finance_fee_collections", ["is_deleted"], :name => "index_finance_fee_collections_on_is_deleted", :limit => {"is_deleted"=>nil}

  create_table "finance_fee_particulars", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "amount",                  :precision => 15, :scale => 4
    t.integer  "finance_fee_category_id"
    t.integer  "student_category_id"
    t.string   "admission_no"
    t.integer  "student_id"
    t.boolean  "is_deleted",                                             :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "batch_id"
    t.boolean  "is_instant",                                             :default => false
  end

  add_index "finance_fee_particulars", ["finance_fee_category_id"], :name => "index_finance_fee_particulars_on_finance_fee_category_id", :limit => {"finance_fee_category_id"=>nil}

  create_table "finance_fee_structure_elements", :force => true do |t|
    t.decimal  "amount",              :precision => 15, :scale => 4
    t.string   "label"
    t.integer  "batch_id"
    t.integer  "student_category_id"
    t.integer  "student_id"
    t.integer  "parent_id"
    t.integer  "fee_collection_id"
    t.boolean  "deleted",                                            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "finance_fees", :force => true do |t|
    t.integer  "fee_collection_id"
    t.string   "transaction_id"
    t.integer  "student_id"
    t.boolean  "is_paid",                                            :default => false
    t.decimal  "balance",             :precision => 15, :scale => 4, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "batch_id"
    t.integer  "student_category_id"
  end

  add_index "finance_fees", ["balance"], :name => "index_finance_fees_on_balance", :limit => {"balance"=>nil}
  add_index "finance_fees", ["batch_id"], :name => "index_finance_fees_on_batch_id", :limit => {"batch_id"=>nil}
  add_index "finance_fees", ["fee_collection_id", "student_id"], :name => "index_finance_fees_on_fee_collection_id_and_student_id", :limit => {"student_id"=>nil, "fee_collection_id"=>nil}
  add_index "finance_fees", ["student_id", "fee_collection_id", "is_paid"], :name => "index_on_is_paid", :limit => {"is_paid"=>nil, "student_id"=>nil, "fee_collection_id"=>nil}

  create_table "finance_transaction_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "is_income"
    t.boolean  "deleted",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tally_ledger_id"
  end

  create_table "finance_transaction_triggers", :force => true do |t|
    t.integer  "finance_category_id"
    t.decimal  "percentage",          :precision => 8, :scale => 2
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "finance_transactions", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.decimal  "amount",                :precision => 15, :scale => 4
    t.boolean  "fine_included",                                        :default => false
    t.integer  "category_id"
    t.integer  "student_id"
    t.integer  "finance_fees_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "transaction_date"
    t.decimal  "fine_amount",           :precision => 15, :scale => 4, :default => 0.0
    t.integer  "master_transaction_id",                                :default => 0
    t.integer  "finance_id"
    t.string   "finance_type"
    t.integer  "payee_id"
    t.string   "payee_type"
    t.string   "receipt_no"
    t.string   "voucher_no"
    t.string   "payment_mode"
    t.text     "payment_note"
    t.integer  "user_id"
    t.integer  "batch_id"
    t.decimal  "auto_fine",             :precision => 15, :scale => 4
    t.string   "reference_no"
    t.string   "trans_type",                                           :default => "collection_wise"
    t.integer  "lastvchid"
  end

  add_index "finance_transactions", ["batch_id"], :name => "index_finance_transactions_on_batch_id", :limit => {"batch_id"=>nil}
  add_index "finance_transactions", ["finance_id", "finance_type"], :name => "index_finance_transactions_on_finance_id_and_finance_type", :limit => {"finance_id"=>nil, "finance_type"=>nil}
  add_index "finance_transactions", ["payee_id", "payee_type"], :name => "index_finance_transactions_on_payee_id_and_payee_type", :limit => {"payee_id"=>nil, "payee_type"=>nil}
  add_index "finance_transactions", ["receipt_no", "voucher_no"], :name => "index_finance_transactions_on_receipt_no_and_voucher_no", :limit => {"voucher_no"=>nil, "receipt_no"=>nil}

  create_table "fine_rules", :force => true do |t|
    t.integer  "fine_id"
    t.integer  "fine_days"
    t.decimal  "fine_amount", :precision => 10, :scale => 4
    t.boolean  "is_amount"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fine_rules", ["fine_id"], :name => "index_fine_rules_on_fine_id", :limit => {"fine_id"=>nil}

  create_table "fines", :force => true do |t|
    t.string   "name"
    t.boolean  "is_deleted", :default => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "form_field_options", :force => true do |t|
    t.text     "label"
    t.integer  "form_field_id"
    t.integer  "placement_order"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight"
    t.integer  "school_id"
  end

  add_index "form_field_options", ["form_field_id"], :name => "index_by_field_id", :limit => {"form_field_id"=>nil}

  create_table "form_fields", :force => true do |t|
    t.text     "label"
    t.integer  "form_template_id"
    t.string   "field_type"
    t.text     "field_settings"
    t.integer  "placement_order"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "form_fields", ["form_template_id"], :name => "index_by_template_id", :limit => {"form_template_id"=>nil}

  create_table "form_file_attachments", :force => true do |t|
    t.integer  "form_field_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "school_id"
  end

  add_index "form_file_attachments", ["form_field_file_id"], :name => "index_by_file_field_id", :limit => {"form_field_file_id"=>nil}

  create_table "form_submissions", :force => true do |t|
    t.integer  "form_id"
    t.text     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "target"
    t.integer  "school_id"
    t.integer  "ward_id"
  end

  add_index "form_submissions", ["target", "ward_id", "form_id"], :name => "index_by_form_and_form_viewers", :limit => {"form_id"=>nil, "target"=>nil, "ward_id"=>nil}

  create_table "form_targets_users", :id => false, :force => true do |t|
    t.integer "form_id"
    t.integer "user_id"
  end

  add_index "form_targets_users", ["user_id", "form_id"], :name => "index_by_form_target_users", :limit => {"form_id"=>nil, "user_id"=>nil}

  create_table "form_templates", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_deleted", :default => false
    t.integer  "school_id"
  end

  add_index "form_templates", ["user_id"], :name => "index_by_users", :limit => {"user_id"=>nil}

  create_table "forms", :force => true do |t|
    t.integer  "form_template_id"
    t.string   "name"
    t.integer  "user_id"
    t.boolean  "is_public",           :default => true
    t.boolean  "is_closed",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_multi_submitable", :default => false
    t.boolean  "is_feedback",         :default => false
    t.integer  "is_parent",           :default => 1
    t.boolean  "is_editable",         :default => false
    t.boolean  "is_targeted"
    t.integer  "school_id"
  end

  add_index "forms", ["form_template_id", "is_closed", "is_public", "is_feedback", "is_targeted"], :name => "index_by_form_properties", :limit => {"form_template_id"=>nil, "is_public"=>nil, "is_targeted"=>nil, "is_feedback"=>nil, "is_closed"=>nil}

  create_table "forms_users", :id => false, :force => true do |t|
    t.integer "form_id"
    t.integer "user_id"
  end

  add_index "forms_users", ["user_id", "form_id"], :name => "index_by_fields", :limit => {"form_id"=>nil, "user_id"=>nil}

  create_table "gallery_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "is_delete",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "gallery_categories", ["school_id"], :name => "index_gallery_categories_on_school_id", :limit => {"school_id"=>nil}

  create_table "gallery_photos", :force => true do |t|
    t.integer  "gallery_category_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "name"
    t.integer  "school_id"
  end

  add_index "gallery_photos", ["school_id"], :name => "index_gallery_photos_on_school_id", :limit => {"school_id"=>nil}

  create_table "gallery_tags", :force => true do |t|
    t.integer  "gallery_photo_id"
    t.integer  "member_id"
    t.string   "member_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "gallery_tags", ["school_id"], :name => "index_gallery_tags_on_school_id", :limit => {"school_id"=>nil}

  create_table "grading_levels", :force => true do |t|
    t.string   "name"
    t.integer  "batch_id"
    t.integer  "min_score"
    t.integer  "order"
    t.boolean  "is_deleted",                                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "credit_points", :precision => 15, :scale => 2
    t.string   "description"
  end

  add_index "grading_levels", ["batch_id", "is_deleted"], :name => "index_grading_levels_on_batch_id_and_is_deleted", :limit => {"batch_id"=>nil, "is_deleted"=>nil}

  create_table "grn_items", :force => true do |t|
    t.integer  "quantity"
    t.decimal  "unit_price",    :precision => 12, :scale => 4
    t.decimal  "tax",           :precision => 10, :scale => 4
    t.decimal  "discount",      :precision => 10, :scale => 4
    t.datetime "expiry_date"
    t.boolean  "is_deleted",                                   :default => false
    t.integer  "grn_id"
    t.integer  "store_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "grn_items", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "grns", :force => true do |t|
    t.string   "grn_no"
    t.string   "invoice_no"
    t.datetime "grn_date"
    t.datetime "invoice_date"
    t.decimal  "other_charges",          :precision => 10, :scale => 4
    t.boolean  "is_deleted",                                            :default => false
    t.integer  "purchase_order_id"
    t.integer  "finance_transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "grns", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "group_files", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "file_description"
    t.integer  "group_post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
    t.integer  "school_id"
  end

  add_index "group_files", ["school_id"], :name => "index_group_files_on_school_id", :limit => {"school_id"=>nil}

  create_table "group_members", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "is_admin",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "group_members", ["school_id"], :name => "index_group_members_on_school_id", :limit => {"school_id"=>nil}

  create_table "group_post_comments", :force => true do |t|
    t.integer  "group_post_id"
    t.integer  "user_id"
    t.text     "comment_body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "group_post_comments", ["school_id"], :name => "index_group_post_comments_on_school_id", :limit => {"school_id"=>nil}

  create_table "group_posts", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "post_title"
    t.text     "post_body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "group_posts", ["school_id"], :name => "index_group_posts_on_school_id", :limit => {"school_id"=>nil}

  create_table "grouped_batches", :force => true do |t|
    t.integer  "batch_group_id"
    t.integer  "batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grouped_batches", ["batch_group_id"], :name => "index_grouped_batches_on_batch_group_id", :limit => {"batch_group_id"=>nil}

  create_table "grouped_exam_reports", :force => true do |t|
    t.integer  "batch_id"
    t.integer  "student_id"
    t.integer  "exam_group_id"
    t.decimal  "marks",         :precision => 15, :scale => 2
    t.string   "score_type"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grouped_exam_reports", ["batch_id", "student_id", "score_type"], :name => "by_batch_student_and_score_type", :limit => {"batch_id"=>nil, "score_type"=>nil, "student_id"=>nil}

  create_table "grouped_exams", :force => true do |t|
    t.integer  "exam_group_id"
    t.integer  "batch_id"
    t.decimal  "weightage",     :precision => 15, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grouped_exams", ["batch_id", "exam_group_id"], :name => "index_grouped_exams_on_batch_id_and_exam_group_id", :limit => {"batch_id"=>nil, "exam_group_id"=>nil}
  add_index "grouped_exams", ["batch_id"], :name => "index_grouped_exams_on_batch_id", :limit => {"batch_id"=>nil}

  create_table "groups", :force => true do |t|
    t.string   "group_name"
    t.text     "group_description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "school_id"
  end

  add_index "groups", ["school_id"], :name => "index_groups_on_school_id", :limit => {"school_id"=>nil}

  create_table "guardians", :force => true do |t|
    t.integer  "ward_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "relation"
    t.string   "email"
    t.string   "office_phone1"
    t.string   "office_phone2"
    t.string   "mobile_phone"
    t.string   "office_address_line1"
    t.string   "office_address_line2"
    t.string   "city"
    t.string   "state"
    t.integer  "country_id"
    t.date     "dob"
    t.string   "occupation"
    t.string   "income"
    t.string   "education"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "guardians", ["first_name", "last_name", "relation"], :name => "ward_guardian_index", :limit => {"relation"=>nil, "first_name"=>nil, "last_name"=>nil}
  add_index "guardians", ["user_id"], :name => "index_guardians_on_user_id", :limit => {"user_id"=>nil}
  add_index "guardians", ["ward_id", "first_name", "last_name", "relation"], :name => "ward_guardian_unique_index", :unique => true, :limit => {"relation"=>nil, "first_name"=>nil, "ward_id"=>nil, "last_name"=>nil}

  create_table "hostel_additional_field_options", :force => true do |t|
    t.string   "field_option"
    t.integer  "hostel_additional_field_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hostel_fee_collections", :force => true do |t|
    t.string   "name"
    t.integer  "batch_id"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "due_date"
    t.boolean  "is_deleted", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "hostel_fee_collections", ["batch_id"], :name => "index_hostel_fee_collections_on_batch_id", :limit => {"batch_id"=>nil}
  add_index "hostel_fee_collections", ["due_date"], :name => "index_hostel_fee_collections_on_due_date", :limit => {"due_date"=>nil}
  add_index "hostel_fee_collections", ["is_deleted", "due_date"], :name => "is_deleted_and_due_date", :limit => {"due_date"=>nil, "is_deleted"=>nil}
  add_index "hostel_fee_collections", ["is_deleted"], :name => "index_hostel_fee_collections_on_is_deleted", :limit => {"is_deleted"=>nil}
  add_index "hostel_fee_collections", ["school_id"], :name => "index_hostel_fee_collections_on_school_id", :limit => {"school_id"=>nil}

  create_table "hostel_fees", :force => true do |t|
    t.integer  "student_id"
    t.integer  "finance_transaction_id"
    t.integer  "hostel_fee_collection_id"
    t.decimal  "rent",                     :precision => 15, :scale => 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.boolean  "is_active",                                               :default => true
    t.integer  "batch_id"
  end

  add_index "hostel_fees", ["batch_id"], :name => "index_hostel_fees_on_batch_id", :limit => {"batch_id"=>nil}
  add_index "hostel_fees", ["hostel_fee_collection_id"], :name => "index_hostel_fees_on_hostel_fee_collection_id", :limit => {"hostel_fee_collection_id"=>nil}
  add_index "hostel_fees", ["rent"], :name => "index_hostel_fees_on_rent", :limit => {"rent"=>nil}
  add_index "hostel_fees", ["school_id"], :name => "index_hostel_fees_on_school_id", :limit => {"school_id"=>nil}
  add_index "hostel_fees", ["student_id", "finance_transaction_id"], :name => "index_on_finance_transactions", :limit => {"student_id"=>nil, "finance_transaction_id"=>nil}

  create_table "hostel_room_additional_details", :force => true do |t|
    t.integer  "linkable_id"
    t.string   "linkable_type"
    t.integer  "hostel_room_additional_field_id"
    t.string   "additional_info"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hostel_room_additional_fields", :force => true do |t|
    t.string   "name"
    t.boolean  "is_mandatory"
    t.string   "input_type"
    t.integer  "priority"
    t.boolean  "is_active"
    t.integer  "school_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hostels", :force => true do |t|
    t.string   "name"
    t.string   "hostel_type"
    t.string   "other_info"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "hostels", ["school_id"], :name => "index_hostels_on_school_id", :limit => {"school_id"=>nil}

  create_table "ia_calculations", :force => true do |t|
    t.string   "formula"
    t.integer  "ia_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ia_groups", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "icse_exam_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ia_groups_subjects", :id => false, :force => true do |t|
    t.integer "ia_group_id"
    t.integer "subject_id"
  end

  add_index "ia_groups_subjects", ["ia_group_id", "subject_id"], :name => "index_by_fields", :limit => {"ia_group_id"=>nil, "subject_id"=>nil}

  create_table "ia_indicators", :force => true do |t|
    t.string   "name"
    t.decimal  "max_mark",    :precision => 15, :scale => 2
    t.string   "indicator"
    t.integer  "ia_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ia_indicators", ["ia_group_id"], :name => "index_ia_indicators_on_ia_group_id", :limit => {"ia_group_id"=>nil}

  create_table "ia_scores", :force => true do |t|
    t.decimal  "mark",            :precision => 15, :scale => 2
    t.integer  "student_id"
    t.integer  "exam_id"
    t.integer  "batch_id"
    t.integer  "ia_indicator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ia_scores", ["ia_indicator_id"], :name => "index_ia_scores_on_ia_indicator_id", :limit => {"ia_indicator_id"=>nil}

  create_table "icse_exam_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_detailed_report", :default => true
  end

  create_table "icse_reports", :force => true do |t|
    t.integer  "batch_id"
    t.integer  "exam_id"
    t.integer  "student_id"
    t.decimal  "ia_score",    :precision => 15, :scale => 2
    t.decimal  "ea_score",    :precision => 15, :scale => 2
    t.decimal  "ia_mark",     :precision => 15, :scale => 2
    t.decimal  "ea_mark",     :precision => 15, :scale => 2
    t.decimal  "total_score", :precision => 15, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "icse_reports", ["exam_id"], :name => "index_icse_reports_on_exam_id", :limit => {"exam_id"=>nil}

  create_table "icse_weightages", :force => true do |t|
    t.string   "name"
    t.integer  "icse_exam_category_id"
    t.decimal  "ea_weightage",          :precision => 15, :scale => 2
    t.decimal  "ia_weightage",          :precision => 15, :scale => 2
    t.boolean  "is_grade",                                             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_co_curricular",                                     :default => false
    t.string   "grade_type"
  end

  create_table "icse_weightages_subjects", :id => false, :force => true do |t|
    t.integer "icse_weightage_id"
    t.integer "subject_id"
  end

  add_index "icse_weightages_subjects", ["icse_weightage_id", "subject_id"], :name => "index_by_fields", :limit => {"icse_weightage_id"=>nil, "subject_id"=>nil}

  create_table "import_log_details", :force => true do |t|
    t.integer  "import_id"
    t.string   "model"
    t.string   "status"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "import_log_details", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "imports", :force => true do |t|
    t.integer  "export_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.string   "csv_file_file_name"
    t.string   "csv_file_content_type"
    t.integer  "csv_file_file_size"
    t.datetime "csv_file_updated_at"
    t.boolean  "is_edit",               :default => false
  end

  add_index "imports", ["export_id"], :name => "index_imports_on_export_id", :limit => {"export_id"=>nil}
  add_index "imports", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "indent_items", :force => true do |t|
    t.integer  "quantity"
    t.string   "batch_no"
    t.integer  "pending"
    t.integer  "issued"
    t.string   "issued_type"
    t.decimal  "price",         :precision => 12, :scale => 4
    t.integer  "required"
    t.boolean  "is_deleted",                                   :default => false
    t.integer  "indent_id"
    t.integer  "store_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "indent_items", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "indents", :force => true do |t|
    t.string   "indent_no"
    t.datetime "expected_date"
    t.string   "status"
    t.boolean  "is_deleted",    :default => false
    t.text     "description"
    t.integer  "user_id"
    t.integer  "store_id"
    t.integer  "manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "indents", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "individual_payslip_categories", :force => true do |t|
    t.integer  "employee_id"
    t.date     "salary_date"
    t.string   "name"
    t.string   "amount"
    t.boolean  "is_deduction"
    t.boolean  "include_every_month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instant_fee_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "is_deleted",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "instant_fee_categories", ["school_id"], :name => "index_instant_fee_categories_on_school_id", :limit => {"school_id"=>nil}

  create_table "instant_fee_details", :force => true do |t|
    t.integer  "instant_fee_id"
    t.integer  "instant_fee_particular_id"
    t.string   "custom_particular"
    t.decimal  "amount",                    :precision => 15, :scale => 4
    t.decimal  "discount",                  :precision => 15, :scale => 4
    t.decimal  "net_amount",                :precision => 15, :scale => 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "instant_fee_details", ["school_id"], :name => "index_instant_fee_details_on_school_id", :limit => {"school_id"=>nil}

  create_table "instant_fee_particulars", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "amount",                  :precision => 15, :scale => 4
    t.integer  "instant_fee_category_id"
    t.boolean  "is_deleted",                                             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "instant_fee_particulars", ["school_id"], :name => "index_instant_fee_particulars_on_school_id", :limit => {"school_id"=>nil}

  create_table "instant_fees", :force => true do |t|
    t.integer  "instant_fee_category_id"
    t.string   "custom_category"
    t.integer  "payee_id"
    t.string   "payee_type"
    t.string   "guest_payee"
    t.decimal  "amount",                  :precision => 15, :scale => 4
    t.datetime "pay_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.text     "custom_description"
    t.string   "groupable_type"
    t.integer  "groupable_id"
  end

  add_index "instant_fees", ["groupable_id", "groupable_type"], :name => "index_instant_fees_on_groupable_id_and_groupable_type", :limit => {"groupable_id"=>nil, "groupable_type"=>nil}
  add_index "instant_fees", ["instant_fee_category_id"], :name => "index_instant_fees_on_instant_fee_category_id", :limit => {"instant_fee_category_id"=>nil}
  add_index "instant_fees", ["payee_id", "payee_type"], :name => "index_instant_fees_on_payee_id_and_payee_type", :limit => {"payee_id"=>nil, "payee_type"=>nil}
  add_index "instant_fees", ["school_id"], :name => "index_instant_fees_on_school_id", :limit => {"school_id"=>nil}

  create_table "invoices", :force => true do |t|
    t.string   "invoice_no"
    t.date     "date"
    t.decimal  "tax",        :precision => 15, :scale => 2
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.boolean  "is_paid",                                   :default => false
  end

  add_index "invoices", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "item_categories", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.boolean  "is_deleted", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "item_categories", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "liabilities", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "amount",      :precision => 15, :scale => 4
    t.boolean  "is_solved",                                  :default => false
    t.boolean  "is_deleted",                                 :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "library_card_settings", :force => true do |t|
    t.integer  "course_id"
    t.integer  "student_category_id"
    t.integer  "books_issueable"
    t.integer  "time_period",         :default => 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "library_card_settings", ["school_id"], :name => "index_library_card_settings_on_school_id", :limit => {"school_id"=>nil}

  create_table "menu_link_categories", :force => true do |t|
    t.string   "name"
    t.text     "allowed_roles"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "origin_name"
  end

  create_table "menu_links", :force => true do |t|
    t.string   "name"
    t.string   "target_controller"
    t.string   "target_action"
    t.integer  "higher_link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_class"
    t.string   "link_type"
    t.string   "user_type"
    t.integer  "menu_link_category_id"
  end

  create_table "monthly_payslips", :force => true do |t|
    t.date     "salary_date"
    t.integer  "employee_id"
    t.integer  "payroll_category_id"
    t.string   "amount"
    t.boolean  "is_approved",            :default => false, :null => false
    t.integer  "approver_id"
    t.boolean  "is_rejected",            :default => false, :null => false
    t.integer  "rejector_id"
    t.string   "reason"
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "finance_transaction_id"
  end

  create_table "multi_fees_transactions", :force => true do |t|
    t.decimal  "amount",           :precision => 15, :scale => 2
    t.string   "payment_mode"
    t.text     "payment_note"
    t.date     "transaction_date"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reference_no"
  end

  create_table "multi_fees_transactions_finance_transactions", :id => false, :force => true do |t|
    t.integer "multi_fees_transaction_id"
    t.integer "finance_transaction_id"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_comments", :force => true do |t|
    t.text     "content"
    t.integer  "news_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_approved", :default => false
  end

  create_table "oauth_authorizations", :force => true do |t|
    t.string   "user_id"
    t.integer  "oauth_client_id"
    t.string   "code"
    t.integer  "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_clients", :force => true do |t|
    t.string   "name"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "redirect_uri"
    t.boolean  "verified"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_tokens", :force => true do |t|
    t.string   "user_id"
    t.integer  "oauth_client_id"
    t.string   "access_token"
    t.string   "refresh_token"
    t.integer  "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "observation_groups", :force => true do |t|
    t.string   "name"
    t.string   "header_name"
    t.string   "desc"
    t.string   "cce_grade_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "observation_kind"
    t.float    "max_marks"
    t.boolean  "is_deleted",       :default => false
    t.integer  "sort_order"
  end

  create_table "observations", :force => true do |t|
    t.string   "name"
    t.string   "desc"
    t.boolean  "is_active"
    t.integer  "observation_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_order"
  end

  add_index "observations", ["observation_group_id"], :name => "index_observations_on_observation_group_id", :limit => {"observation_group_id"=>nil}

  create_table "online_exam_attendances", :force => true do |t|
    t.integer  "online_exam_group_id"
    t.integer  "student_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.decimal  "total_score",          :precision => 7, :scale => 2
    t.boolean  "is_passed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.boolean  "answers_evaluated",                                  :default => false
  end

  add_index "online_exam_attendances", ["online_exam_group_id", "student_id"], :name => "by_exam_and_student", :limit => {"student_id"=>nil, "online_exam_group_id"=>nil}
  add_index "online_exam_attendances", ["school_id"], :name => "index_online_exam_attendances_on_school_id", :limit => {"school_id"=>nil}

  create_table "online_exam_groups", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "maximum_time",        :precision => 7, :scale => 2
    t.decimal  "pass_percentage",     :precision => 6, :scale => 2
    t.integer  "option_count"
    t.integer  "batch_id"
    t.boolean  "is_deleted",                                        :default => false
    t.boolean  "is_published",                                      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.string   "exam_type"
    t.string   "exam_format"
    t.boolean  "result_published",                                  :default => false
    t.boolean  "randomize_questions",                               :default => false
  end

  add_index "online_exam_groups", ["school_id"], :name => "index_online_exam_groups_on_school_id", :limit => {"school_id"=>nil}

  create_table "online_exam_groups_batches", :id => false, :force => true do |t|
    t.integer "online_exam_group_id"
    t.integer "batch_id"
  end

  add_index "online_exam_groups_batches", ["batch_id"], :name => "index_online_exam_groups_batches_on_batch_id", :limit => {"batch_id"=>nil}
  add_index "online_exam_groups_batches", ["online_exam_group_id"], :name => "index_online_exam_groups_batches_on_online_exam_group_id", :limit => {"online_exam_group_id"=>nil}

  create_table "online_exam_groups_employees", :id => false, :force => true do |t|
    t.integer "online_exam_group_id"
    t.integer "employee_id"
  end

  add_index "online_exam_groups_employees", ["employee_id"], :name => "index_online_exam_groups_employees_on_employee_id", :limit => {"employee_id"=>nil}
  add_index "online_exam_groups_employees", ["online_exam_group_id"], :name => "index_online_exam_groups_employees_on_online_exam_group_id", :limit => {"online_exam_group_id"=>nil}

  create_table "online_exam_groups_questions", :force => true do |t|
    t.integer  "online_exam_group_id"
    t.integer  "online_exam_question_id"
    t.decimal  "mark",                    :precision => 15, :scale => 4
    t.text     "answer_ids"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "online_exam_groups_questions", ["online_exam_question_id", "online_exam_group_id"], :name => "groups_questions_unique_index", :unique => true, :limit => {"online_exam_question_id"=>nil, "online_exam_group_id"=>nil}
  add_index "online_exam_groups_questions", ["school_id"], :name => "index_online_exam_groups_questions_on_school_id", :limit => {"school_id"=>nil}

  create_table "online_exam_groups_students", :id => false, :force => true do |t|
    t.integer "online_exam_group_id"
    t.integer "student_id"
  end

  add_index "online_exam_groups_students", ["online_exam_group_id"], :name => "index_online_exam_groups_students_on_online_exam_group_id", :limit => {"online_exam_group_id"=>nil}
  add_index "online_exam_groups_students", ["student_id"], :name => "index_online_exam_groups_students_on_student_id", :limit => {"student_id"=>nil}

  create_table "online_exam_groups_subjects", :id => false, :force => true do |t|
    t.integer "online_exam_group_id"
    t.integer "subject_id"
  end

  add_index "online_exam_groups_subjects", ["online_exam_group_id"], :name => "index_online_exam_groups_subjects_on_online_exam_group_id", :limit => {"online_exam_group_id"=>nil}

  create_table "online_exam_options", :force => true do |t|
    t.integer  "online_exam_question_id"
    t.text     "option"
    t.boolean  "is_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "online_exam_options", ["is_answer"], :name => "index_online_exam_options_on_is_answer", :limit => {"is_answer"=>nil}
  add_index "online_exam_options", ["online_exam_question_id"], :name => "index_online_exam_options_on_online_exam_question_id", :limit => {"online_exam_question_id"=>nil}
  add_index "online_exam_options", ["school_id"], :name => "index_online_exam_options_on_school_id", :limit => {"school_id"=>nil}

  create_table "online_exam_questions", :force => true do |t|
    t.integer  "online_exam_group_id"
    t.text     "question"
    t.decimal  "mark",                 :precision => 7, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.integer  "subject_id"
    t.string   "question_format"
  end

  add_index "online_exam_questions", ["question_format", "subject_id"], :name => "by_format_and_subject", :limit => {"question_format"=>nil, "subject_id"=>nil}
  add_index "online_exam_questions", ["school_id"], :name => "index_online_exam_questions_on_school_id", :limit => {"school_id"=>nil}

  create_table "online_exam_score_details", :force => true do |t|
    t.integer  "online_exam_question_id"
    t.integer  "online_exam_attendance_id"
    t.integer  "online_exam_option_id"
    t.boolean  "is_correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.integer  "online_exam_group_id"
    t.decimal  "marks_obtained",            :precision => 15, :scale => 2
    t.text     "answer"
  end

  add_index "online_exam_score_details", ["online_exam_attendance_id"], :name => "index_online_exam_score_details_on_online_exam_attendance_id", :limit => {"online_exam_attendance_id"=>nil}
  add_index "online_exam_score_details", ["online_exam_option_id", "online_exam_question_id", "online_exam_attendance_id"], :name => "score_details_index", :limit => {"online_exam_option_id"=>nil, "online_exam_attendance_id"=>nil, "online_exam_question_id"=>nil}
  add_index "online_exam_score_details", ["online_exam_option_id", "online_exam_question_id", "online_exam_attendance_id"], :name => "score_details_unique_index", :unique => true, :limit => {"online_exam_option_id"=>nil, "online_exam_attendance_id"=>nil, "online_exam_question_id"=>nil}
  add_index "online_exam_score_details", ["school_id"], :name => "index_online_exam_score_details_on_school_id", :limit => {"school_id"=>nil}

  create_table "online_meeting_members", :force => true do |t|
    t.integer  "member_id"
    t.integer  "online_meeting_room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "online_meeting_members", ["school_id"], :name => "index_online_meeting_members_on_school_id", :limit => {"school_id"=>nil}

  create_table "online_meeting_rooms", :force => true do |t|
    t.integer  "server_id"
    t.integer  "user_id"
    t.string   "meetingid"
    t.string   "name"
    t.string   "attendee_password"
    t.string   "moderator_password"
    t.string   "welcome_msg"
    t.string   "logout_url"
    t.string   "voice_bridge"
    t.string   "dial_number"
    t.integer  "max_participants"
    t.boolean  "private",             :default => false
    t.boolean  "randomize_meetingid", :default => true
    t.boolean  "external",            :default => false
    t.string   "param"
    t.datetime "scheduled_on"
    t.boolean  "is_active",           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "online_meeting_rooms", ["meetingid"], :name => "index_online_meeting_rooms_on_meetingid", :unique => true, :limit => {"meetingid"=>nil}
  add_index "online_meeting_rooms", ["school_id"], :name => "index_online_meeting_rooms_on_school_id", :limit => {"school_id"=>nil}
  add_index "online_meeting_rooms", ["server_id"], :name => "index_online_meeting_rooms_on_server_id", :limit => {"server_id"=>nil}
  add_index "online_meeting_rooms", ["voice_bridge"], :name => "index_online_meeting_rooms_on_voice_bridge", :unique => true, :limit => {"voice_bridge"=>nil}

  create_table "online_meeting_servers", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "salt"
    t.string   "version"
    t.string   "param"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "online_meeting_servers", ["school_id"], :name => "index_online_meeting_servers_on_school_id", :limit => {"school_id"=>nil}

  create_table "palette_queries", :force => true do |t|
    t.integer  "palette_id"
    t.text     "user_roles"
    t.text     "query"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "parameters"
  end

  create_table "palettes", :force => true do |t|
    t.string   "name"
    t.string   "model_name"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "plugin"
  end

  add_index "palettes", ["name"], :name => "index_palettes_on_name", :limit => {"name"=>nil}

  create_table "particular_discounts", :force => true do |t|
    t.decimal  "discount",              :precision => 15, :scale => 4
    t.integer  "particular_payment_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "particular_payments", :force => true do |t|
    t.decimal  "amount",                    :precision => 15, :scale => 4
    t.integer  "finance_fee_id"
    t.integer  "finance_fee_particular_id"
    t.integer  "finance_transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_configurations", :force => true do |t|
    t.string   "config_key"
    t.string   "config_value"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.string   "payee_type"
    t.integer  "payee_id"
    t.string   "payment_type"
    t.integer  "payment_id"
    t.text     "gateway_response"
    t.integer  "finance_transaction_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status"
    t.integer  "fee_collection_id"
    t.string   "fee_collection_type"
    t.decimal  "amount",                 :precision => 15, :scale => 4
    t.integer  "status_description"
    t.string   "gateway"
  end

  add_index "payments", ["payee_id"], :name => "index_payments_on_payee_id", :limit => {"payee_id"=>nil}
  add_index "payments", ["payment_id"], :name => "index_payments_on_payment_id", :limit => {"payment_id"=>nil}
  add_index "payments", ["status"], :name => "index_payments_on_status", :limit => {"status"=>nil}

  create_table "payroll_categories", :force => true do |t|
    t.string   "name"
    t.float    "percentage"
    t.integer  "payroll_category_id"
    t.boolean  "is_deduction"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_deleted",          :default => false
  end

  create_table "period_entries", :force => true do |t|
    t.date     "month_date"
    t.integer  "batch_id"
    t.integer  "subject_id"
    t.integer  "class_timing_id"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "period_entries", ["month_date", "batch_id"], :name => "index_period_entries_on_month_date_and_batch_id", :limit => {"batch_id"=>nil, "month_date"=>nil}

  create_table "pin_groups", :force => true do |t|
    t.text     "course_ids"
    t.date     "valid_from"
    t.date     "valid_till"
    t.string   "name"
    t.integer  "pin_count"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  create_table "pin_numbers", :force => true do |t|
    t.string   "number"
    t.boolean  "is_active"
    t.boolean  "is_registered"
    t.integer  "pin_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  create_table "placement_registrations", :force => true do |t|
    t.integer  "student_id"
    t.integer  "placementevent_id"
    t.boolean  "is_applied",        :default => false
    t.boolean  "is_approved"
    t.boolean  "is_attended",       :default => false
    t.boolean  "is_placed",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "placement_registrations", ["school_id"], :name => "index_placement_registrations_on_school_id", :limit => {"school_id"=>nil}

  create_table "placementevents", :force => true do |t|
    t.string   "title"
    t.string   "company"
    t.string   "place"
    t.text     "description"
    t.boolean  "is_active",   :default => true
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "placementevents", ["school_id"], :name => "index_placementevents_on_school_id", :limit => {"school_id"=>nil}

  create_table "poll_members", :force => true do |t|
    t.integer  "poll_question_id"
    t.integer  "member_id"
    t.string   "member_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "poll_members", ["school_id"], :name => "index_poll_members_on_school_id", :limit => {"school_id"=>nil}

  create_table "poll_options", :force => true do |t|
    t.integer  "poll_question_id"
    t.text     "option"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "poll_options", ["school_id"], :name => "index_poll_options_on_school_id", :limit => {"school_id"=>nil}

  create_table "poll_questions", :force => true do |t|
    t.boolean  "is_active"
    t.string   "title"
    t.text     "description"
    t.boolean  "allow_custom_ans"
    t.integer  "poll_creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "poll_questions", ["school_id"], :name => "index_poll_questions_on_school_id", :limit => {"school_id"=>nil}

  create_table "poll_votes", :force => true do |t|
    t.integer  "poll_question_id"
    t.integer  "poll_option_id"
    t.string   "custom_answer"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "poll_votes", ["school_id"], :name => "index_poll_votes_on_school_id", :limit => {"school_id"=>nil}

  create_table "previous_exam_scores", :force => true do |t|
    t.integer  "student_id"
    t.integer  "exam_id"
    t.decimal  "marks",            :precision => 7, :scale => 2
    t.integer  "grading_level_id"
    t.string   "remarks"
    t.boolean  "is_failed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "previous_exam_scores", ["student_id", "exam_id"], :name => "index_previous_exam_scores_on_student_id_and_exam_id", :limit => {"student_id"=>nil, "exam_id"=>nil}

  create_table "privilege_tags", :force => true do |t|
    t.string   "name_tag"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privileges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "privilege_tag_id"
    t.integer  "priority"
  end

  create_table "privileges_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "privilege_id"
  end

  add_index "privileges_users", ["user_id"], :name => "index_privileges_users_on_user_id", :limit => {"user_id"=>nil}

  create_table "purchase_items", :force => true do |t|
    t.integer  "quantity"
    t.decimal  "discount",          :precision => 10, :scale => 4
    t.decimal  "tax",               :precision => 10, :scale => 4
    t.decimal  "price",             :precision => 12, :scale => 4
    t.boolean  "is_deleted",                                       :default => false
    t.integer  "user_id"
    t.integer  "purchase_order_id"
    t.integer  "store_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "purchase_items", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "purchase_orders", :force => true do |t|
    t.string   "po_no"
    t.datetime "po_date"
    t.string   "po_status",        :default => "Pending"
    t.string   "reference"
    t.boolean  "is_deleted",       :default => false
    t.integer  "store_id"
    t.integer  "indent_id"
    t.integer  "supplier_id"
    t.integer  "supplier_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "purchase_orders", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "ranking_levels", :force => true do |t|
    t.string   "name",                                                                 :null => false
    t.decimal  "gpa",                :precision => 15, :scale => 2
    t.decimal  "marks",              :precision => 15, :scale => 2
    t.integer  "subject_count"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "full_course",                                       :default => false
    t.integer  "course_id"
    t.string   "subject_limit_type"
    t.string   "marks_limit_type"
  end

  create_table "record_updates", :force => true do |t|
    t.string   "file_name"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "redactor_uploads", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "is_used",            :default => false
  end

  create_table "refund_rules", :force => true do |t|
    t.integer  "finance_fee_collection_id"
    t.string   "name"
    t.date     "refund_validity"
    t.decimal  "amount",                    :precision => 15, :scale => 4
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_amount",                                                :default => false
  end

  create_table "registration_courses", :force => true do |t|
    t.integer  "school_id"
    t.integer  "course_id"
    t.integer  "minimum_score"
    t.boolean  "is_active"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "subject_based_fee_colletion"
    t.boolean  "enable_approval_system"
    t.integer  "min_electives"
    t.integer  "max_electives"
    t.boolean  "is_subject_based_registration"
    t.boolean  "include_additional_details"
    t.string   "additional_field_ids"
    t.boolean  "transfer_documents",            :default => false
  end

  add_index "registration_courses", ["course_id"], :name => "index_registration_courses_on_course_id", :limit => {"course_id"=>nil}
  add_index "registration_courses", ["school_id"], :name => "index_registration_courses_on_school_id", :limit => {"school_id"=>nil}

  create_table "remark_parameters", :force => true do |t|
    t.integer  "remark_id"
    t.string   "param_name"
    t.string   "param_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "remark_parameters", ["remark_id"], :name => "index_remark_parameters_on_remark_id", :limit => {"remark_id"=>nil}

  create_table "remark_settings", :force => true do |t|
    t.string   "target"
    t.text     "parameters"
    t.string   "table_name"
    t.string   "field_name"
    t.string   "remark_type"
    t.boolean  "general"
    t.string   "load_model"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "remarks", :force => true do |t|
    t.integer  "target_id"
    t.integer  "student_id"
    t.integer  "batch_id"
    t.integer  "submitted_by"
    t.string   "remark_subject"
    t.text     "remark_body"
    t.string   "remarked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "remarks", ["target_id"], :name => "index_remarks_on_target_id", :limit => {"target_id"=>nil}

  create_table "reminders", :force => true do |t|
    t.integer  "sender"
    t.integer  "recipient"
    t.string   "subject"
    t.text     "body"
    t.boolean  "is_read",                 :default => false
    t.boolean  "is_deleted_by_sender",    :default => false
    t.boolean  "is_deleted_by_recipient", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reminders", ["recipient"], :name => "index_reminders_on_recipient", :limit => {"recipient"=>nil}

  create_table "report_columns", :force => true do |t|
    t.integer  "report_id"
    t.string   "title"
    t.string   "method"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.string   "association_method"
  end

  add_index "report_columns", ["report_id"], :name => "index_report_columns_on_report_id", :limit => {"report_id"=>nil}
  add_index "report_columns", ["school_id"], :name => "index_report_columns_on_school_id", :limit => {"school_id"=>nil}

  create_table "report_queries", :force => true do |t|
    t.integer  "report_id"
    t.string   "table_name"
    t.string   "column_name"
    t.string   "criteria"
    t.text     "query"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "column_type"
    t.integer  "school_id"
  end

  add_index "report_queries", ["report_id"], :name => "index_report_queries_on_report_id", :limit => {"report_id"=>nil}
  add_index "report_queries", ["school_id"], :name => "index_report_queries_on_school_id", :limit => {"school_id"=>nil}

  create_table "reports", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "model"
    t.integer  "school_id"
  end

  add_index "reports", ["school_id"], :name => "index_reports_on_school_id", :limit => {"school_id"=>nil}

  create_table "room_additional_field_options", :force => true do |t|
    t.string   "field_option"
    t.integer  "room_additional_field_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "room_allocations", :force => true do |t|
    t.integer  "room_detail_id"
    t.integer  "student_id"
    t.boolean  "is_vacated",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "room_allocations", ["room_detail_id"], :name => "index_room_allocations_on_room_detail_id", :limit => {"room_detail_id"=>nil}
  add_index "room_allocations", ["school_id"], :name => "index_room_allocations_on_school_id", :limit => {"school_id"=>nil}

  create_table "room_details", :force => true do |t|
    t.integer  "hostel_id"
    t.string   "room_number"
    t.integer  "students_per_room"
    t.decimal  "rent",              :precision => 15, :scale => 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "room_details", ["hostel_id"], :name => "index_room_details_on_hostel_id", :limit => {"hostel_id"=>nil}
  add_index "room_details", ["school_id"], :name => "index_room_details_on_school_id", :limit => {"school_id"=>nil}

  create_table "route_additional_field_options", :force => true do |t|
    t.string   "field_option"
    t.integer  "route_additional_field_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "route_vehicle_additional_details", :force => true do |t|
    t.integer  "linkable_id"
    t.string   "linkable_type"
    t.integer  "route_vehicle_additional_field_id"
    t.string   "additional_info"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "route_vehicle_additional_fields", :force => true do |t|
    t.string   "name"
    t.boolean  "is_mandatory"
    t.string   "input_type"
    t.integer  "priority"
    t.boolean  "is_active"
    t.integer  "school_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routes", :force => true do |t|
    t.string   "destination"
    t.string   "cost"
    t.integer  "main_route_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "routes", ["school_id"], :name => "index_routes_on_school_id", :limit => {"school_id"=>nil}

  create_table "sales_user_details", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "address"
    t.integer  "batch_id"
    t.integer  "invoice_id"
    t.string   "invoice_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.integer  "issuer_id"
  end

  add_index "sales_user_details", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "school_assets", :force => true do |t|
    t.string   "asset_name"
    t.string   "asset_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "school_assets", ["school_id"], :name => "index_school_assets_on_school_id", :limit => {"school_id"=>nil}

  create_table "school_details", :force => true do |t|
    t.integer  "school_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.string   "logo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "logo_updated_at"
  end

  create_table "single_access_tokens", :force => true do |t|
    t.string   "client_name"
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_logs", :force => true do |t|
    t.string   "mobile"
    t.string   "gateway_response"
    t.string   "sms_message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_messages", :force => true do |t|
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_settings", :force => true do |t|
    t.string   "settings_key"
    t.boolean  "is_enabled",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sold_items", :force => true do |t|
    t.integer  "store_item_id"
    t.integer  "invoice_id"
    t.integer  "quantity"
    t.string   "code"
    t.string   "invoice_type"
    t.decimal  "rate",          :precision => 15, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "sold_items", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "store_categories", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.boolean  "is_deleted", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "store_categories", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "store_items", :force => true do |t|
    t.string   "item_name"
    t.integer  "quantity"
    t.decimal  "unit_price",       :precision => 12, :scale => 4
    t.decimal  "tax",              :precision => 10, :scale => 4
    t.string   "batch_number"
    t.boolean  "is_deleted",                                      :default => false
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.string   "code"
    t.boolean  "sellable"
    t.integer  "item_category_id"
  end

  add_index "store_items", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "store_types", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.boolean  "is_deleted", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "store_types", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.boolean  "is_deleted",        :default => false
    t.integer  "store_category_id"
    t.integer  "store_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.string   "invoice_prefix"
  end

  add_index "stores", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "student_additional_details", :force => true do |t|
    t.integer  "student_id"
    t.integer  "additional_field_id"
    t.string   "additional_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_additional_details", ["student_id", "additional_field_id"], :name => "student_data_index", :limit => {"additional_field_id"=>nil, "student_id"=>nil}

  create_table "student_additional_field_options", :force => true do |t|
    t.integer  "student_additional_field_id"
    t.string   "field_option"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_additional_fields", :force => true do |t|
    t.string   "name"
    t.boolean  "status"
    t.boolean  "is_mandatory", :default => false
    t.string   "input_type"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_addl_attachments", :force => true do |t|
    t.integer  "school_id"
    t.integer  "student_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_addl_attachments", ["student_id"], :name => "index_student_addl_attachments_on_student_id", :limit => {"student_id"=>nil}

  create_table "student_categories", :force => true do |t|
    t.string   "name"
    t.boolean  "is_deleted", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_deletion_logs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "student_id"
    t.text     "dependency_messages"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stud_adm_no"
  end

  create_table "student_previous_datas", :force => true do |t|
    t.integer  "student_id"
    t.string   "institution"
    t.string   "year"
    t.string   "course"
    t.string   "total_mark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_previous_subject_marks", :force => true do |t|
    t.integer  "student_id"
    t.string   "subject"
    t.string   "mark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.string   "admission_no"
    t.string   "class_roll_no"
    t.date     "admission_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "batch_id"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "blood_group"
    t.string   "birth_place"
    t.integer  "nationality_id"
    t.string   "language"
    t.string   "religion"
    t.integer  "student_category_id"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "pin_code"
    t.integer  "country_id"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.integer  "immediate_contact_id"
    t.boolean  "is_sms_enabled",                              :default => true
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.binary   "photo_data",              :limit => 16777215
    t.string   "status_description"
    t.boolean  "is_active",                                   :default => true
    t.boolean  "is_deleted",                                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_paid_fees",                               :default => false
    t.integer  "photo_file_size"
    t.integer  "user_id"
    t.boolean  "is_email_enabled",                            :default => true
    t.integer  "sibling_id"
    t.datetime "photo_updated_at"
    t.string   "roll_number"
    t.boolean  "has_paid_fees_for_batch",                     :default => false
    t.string   "library_card"
  end

  add_index "students", ["admission_no"], :name => "admission_no_unique_index", :unique => true, :limit => {"admission_no"=>nil}
  add_index "students", ["admission_no"], :name => "index_students_on_admission_no", :limit => {"admission_no"=>"10"}
  add_index "students", ["batch_id"], :name => "index_students_on_batch_id", :limit => {"batch_id"=>nil}
  add_index "students", ["first_name", "middle_name", "last_name"], :name => "index_students_on_first_name_and_middle_name_and_last_name", :limit => {"middle_name"=>"10", "first_name"=>"10", "last_name"=>"10"}
  add_index "students", ["immediate_contact_id"], :name => "index_students_on_immediate_contact_id", :limit => {"immediate_contact_id"=>nil}
  add_index "students", ["nationality_id", "immediate_contact_id", "student_category_id"], :name => "student_data_index", :limit => {"nationality_id"=>nil, "student_category_id"=>nil, "immediate_contact_id"=>nil}
  add_index "students", ["user_id"], :name => "index_students_on_user_id", :limit => {"user_id"=>nil}

  create_table "students_subjects", :force => true do |t|
    t.integer  "student_id"
    t.integer  "subject_id"
    t.integer  "batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students_subjects", ["student_id", "subject_id"], :name => "index_students_subjects_on_student_id_and_subject_id", :limit => {"student_id"=>nil, "subject_id"=>nil}

  create_table "subject_amounts", :force => true do |t|
    t.integer  "course_id"
    t.decimal  "amount",     :precision => 15, :scale => 4
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subject_leaves", :force => true do |t|
    t.integer  "student_id"
    t.date     "month_date"
    t.integer  "subject_id"
    t.integer  "employee_id"
    t.integer  "class_timing_id"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "batch_id"
  end

  add_index "subject_leaves", ["month_date", "subject_id", "batch_id"], :name => "index_subject_leaves_on_month_date_and_subject_id_and_batch_id", :limit => {"batch_id"=>nil, "month_date"=>nil, "subject_id"=>nil}
  add_index "subject_leaves", ["student_id", "batch_id"], :name => "index_subject_leaves_on_student_id_and_batch_id", :limit => {"batch_id"=>nil, "student_id"=>nil}

  create_table "subject_leaves_teachers", :id => false, :force => true do |t|
    t.integer "employee_id"
    t.integer "subject_leave_id"
  end

  add_index "subject_leaves_teachers", ["employee_id", "subject_leave_id"], :name => "index_by_fields", :limit => {"subject_leave_id"=>nil, "employee_id"=>nil}

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "batch_id"
    t.boolean  "no_exams",                                          :default => false
    t.integer  "max_weekly_classes"
    t.integer  "elective_group_id"
    t.boolean  "is_deleted",                                        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "credit_hours",       :precision => 15, :scale => 2
    t.boolean  "prefer_consecutive",                                :default => false
    t.decimal  "amount",             :precision => 15, :scale => 4
  end

  add_index "subjects", ["batch_id", "elective_group_id", "is_deleted"], :name => "index_subjects_on_batch_id_and_elective_group_id_and_is_deleted", :limit => {"batch_id"=>nil, "elective_group_id"=>nil, "is_deleted"=>nil}

  create_table "supplier_types", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.boolean  "is_deleted", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "supplier_types", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "suppliers", :force => true do |t|
    t.string   "name"
    t.string   "contact_no"
    t.text     "address"
    t.string   "tin_no"
    t.string   "region"
    t.text     "help_desk"
    t.boolean  "is_deleted",       :default => false
    t.integer  "supplier_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "suppliers", ["school_id"], :name => "by_school_id", :limit => {"school_id"=>nil}

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.integer  "school_id"
    t.datetime "updated_at"
  end

  add_index "taggings", ["school_id"], :name => "index_taggings_on_school_id", :limit => {"school_id"=>nil}
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id", :limit => {"tag_id"=>nil}
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type", :limit => {"taggable_type"=>nil, "taggable_id"=>nil}

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["school_id"], :name => "index_tags_on_school_id", :limit => {"school_id"=>nil}

  create_table "tally_accounts", :force => true do |t|
    t.integer  "school_id"
    t.string   "account_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tally_companies", :force => true do |t|
    t.integer  "school_id"
    t.string   "company_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tally_export_configurations", :force => true do |t|
    t.integer  "school_id"
    t.string   "config_key"
    t.string   "config_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tally_export_files", :force => true do |t|
    t.integer  "download_no",              :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.string   "export_file_file_name"
    t.string   "export_file_content_type"
    t.integer  "export_file_file_size"
    t.datetime "export_file_updated_at"
  end

  create_table "tally_export_logs", :force => true do |t|
    t.integer  "school_id"
    t.integer  "finance_transaction_id"
    t.boolean  "status"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tally_export_logs", ["status"], :name => "index_tally_export_logs_on_status", :limit => {"status"=>nil}
  add_index "tally_export_logs", ["updated_at"], :name => "by_updation", :limit => {"updated_at"=>nil}

  create_table "tally_ledgers", :force => true do |t|
    t.integer  "school_id"
    t.string   "ledger_name"
    t.integer  "tally_company_id"
    t.integer  "tally_voucher_type_id"
    t.integer  "tally_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tally_voucher_types", :force => true do |t|
    t.integer  "school_id"
    t.string   "voucher_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_assignees", :force => true do |t|
    t.integer  "task_id"
    t.integer  "assignee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "task_assignees", ["school_id"], :name => "index_task_assignees_on_school_id", :limit => {"school_id"=>nil}

  create_table "task_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.text     "description"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "task_comments", ["school_id"], :name => "index_task_comments_on_school_id", :limit => {"school_id"=>nil}

  create_table "tasks", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.string   "status"
    t.date     "start_date"
    t.date     "due_date"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "tasks", ["school_id"], :name => "index_tasks_on_school_id", :limit => {"school_id"=>nil}

  create_table "teacher_timetable_entries", :id => false, :force => true do |t|
    t.integer "employee_id"
    t.integer "timetable_entry_id"
  end

  add_index "teacher_timetable_entries", ["employee_id", "timetable_entry_id"], :name => "index_by_fields", :limit => {"employee_id"=>nil, "timetable_entry_id"=>nil}

  create_table "time_table_class_timing_sets", :force => true do |t|
    t.integer  "batch_id"
    t.integer  "time_table_class_timing_id"
    t.integer  "class_timing_set_id"
    t.integer  "weekday_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "time_table_class_timing_sets", ["batch_id"], :name => "index_time_table_class_timing_sets_on_batch_id", :limit => {"batch_id"=>nil}
  add_index "time_table_class_timing_sets", ["time_table_class_timing_id", "batch_id", "class_timing_set_id", "weekday_id"], :name => "ttctctsw_index", :limit => {"weekday_id"=>nil, "batch_id"=>nil, "time_table_class_timing_id"=>nil, "class_timing_set_id"=>nil}
  add_index "time_table_class_timing_sets", ["time_table_class_timing_id"], :name => "index_time_table_class_timing_sets_on_time_table_class_timing_id", :limit => {"time_table_class_timing_id"=>nil}

  create_table "time_table_class_timings", :force => true do |t|
    t.integer  "batch_id"
    t.integer  "timetable_id"
    t.integer  "class_timing_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "time_table_class_timings", ["timetable_id", "batch_id"], :name => "timetable_id_and_batch_id_index", :limit => {"batch_id"=>nil, "timetable_id"=>nil}

  create_table "time_table_weekdays", :force => true do |t|
    t.integer  "batch_id"
    t.integer  "timetable_id"
    t.integer  "weekday_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "time_table_weekdays", ["batch_id", "timetable_id"], :name => "batch_timetable_index", :limit => {"batch_id"=>nil, "timetable_id"=>nil}

  create_table "time_zones", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "difference_type"
    t.integer  "time_difference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timetable_entries", :force => true do |t|
    t.integer  "batch_id"
    t.integer  "weekday_id"
    t.integer  "class_timing_id"
    t.integer  "subject_id"
    t.integer  "employee_id"
    t.integer  "timetable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "entry_type"
    t.integer  "entry_id"
  end

  add_index "timetable_entries", ["class_timing_id"], :name => "index_timetable_entries_on_class_timing_id", :limit => {"class_timing_id"=>nil}
  add_index "timetable_entries", ["entry_type", "entry_id"], :name => "timetable_entries_polymorphic_entry_index", :limit => {"entry_type"=>nil, "entry_id"=>nil}
  add_index "timetable_entries", ["timetable_id"], :name => "index_timetable_entries_on_timetable_id", :limit => {"timetable_id"=>nil}

  create_table "timetable_swaps", :force => true do |t|
    t.date     "date"
    t.integer  "timetable_entry_id"
    t.integer  "employee_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timetables", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "is_active",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timetables", ["end_date"], :name => "index_timetables_on_end_date", :limit => {"end_date"=>nil}
  add_index "timetables", ["start_date", "end_date"], :name => "by_start_and_end", :limit => {"end_date"=>nil, "start_date"=>nil}
  add_index "timetables", ["start_date"], :name => "index_timetables_on_start_date", :limit => {"start_date"=>nil}

  create_table "transport_fee_collections", :force => true do |t|
    t.string   "name"
    t.integer  "batch_id"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "due_date"
    t.boolean  "is_deleted", :default => false, :null => false
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transport_fee_collections", ["batch_id"], :name => "index_transport_fee_collections_on_batch_id", :limit => {"batch_id"=>nil}
  add_index "transport_fee_collections", ["due_date"], :name => "index_transport_fee_collections_on_due_date", :limit => {"due_date"=>nil}
  add_index "transport_fee_collections", ["is_deleted", "due_date"], :name => "is_deleted_and_due_date", :limit => {"due_date"=>nil, "is_deleted"=>nil}
  add_index "transport_fee_collections", ["is_deleted"], :name => "index_transport_fee_collections_on_is_deleted", :limit => {"is_deleted"=>nil}
  add_index "transport_fee_collections", ["school_id"], :name => "index_transport_fee_collections_on_school_id", :limit => {"school_id"=>nil}

  create_table "transport_fees", :force => true do |t|
    t.integer  "receiver_id"
    t.decimal  "bus_fare",                    :precision => 15, :scale => 4
    t.integer  "transaction_id"
    t.integer  "transport_fee_collection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "receiver_type"
    t.integer  "school_id"
    t.boolean  "is_active",                                                  :default => true
    t.integer  "groupable_id"
    t.string   "groupable_type"
  end

  add_index "transport_fees", ["bus_fare"], :name => "index_transport_fees_on_bus_fare", :limit => {"bus_fare"=>nil}
  add_index "transport_fees", ["groupable_id", "groupable_type"], :name => "index_transport_fees_on_groupable_id_and_groupable_type", :limit => {"groupable_id"=>nil, "groupable_type"=>nil}
  add_index "transport_fees", ["receiver_id", "receiver_type"], :name => "index_transport_fees_on_receiver_id_and_receiver_type", :limit => {"receiver_type"=>nil, "receiver_id"=>nil}
  add_index "transport_fees", ["receiver_id", "transaction_id"], :name => "indices_on_transactions", :limit => {"transaction_id"=>nil, "receiver_id"=>nil}
  add_index "transport_fees", ["school_id"], :name => "index_transport_fees_on_school_id", :limit => {"school_id"=>nil}
  add_index "transport_fees", ["transport_fee_collection_id"], :name => "transport_fee_collection_id", :limit => {"transport_fee_collection_id"=>nil}

  create_table "transports", :force => true do |t|
    t.integer  "receiver_id"
    t.integer  "vehicle_id"
    t.integer  "route_id"
    t.decimal  "bus_fare",      :precision => 15, :scale => 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "receiver_type"
    t.integer  "school_id"
  end

  add_index "transports", ["school_id"], :name => "index_transports_on_school_id", :limit => {"school_id"=>nil}
  add_index "transports", ["vehicle_id"], :name => "index_transports_on_vehicle_id", :limit => {"vehicle_id"=>nil}

  create_table "user_events", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_events", ["user_id"], :name => "index_user_events_on_user_id", :limit => {"user_id"=>nil}

  create_table "user_menu_links", :force => true do |t|
    t.integer  "user_id"
    t.integer  "menu_link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_menu_links", ["menu_link_id", "user_id"], :name => "on_user_and_link", :limit => {"menu_link_id"=>nil, "user_id"=>nil}

  create_table "user_palettes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "palette_id"
    t.integer  "position"
    t.boolean  "is_minimized",  :default => false
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "column_number"
  end

  add_index "user_palettes", ["school_id"], :name => "index_user_palettes_on_school_id", :limit => {"school_id"=>nil}
  add_index "user_palettes", ["user_id", "palette_id"], :name => "index_user_palettes_on_user_id_and_palette_id", :limit => {"palette_id"=>nil, "user_id"=>nil}

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "admin"
    t.boolean  "student"
    t.boolean  "employee"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "reset_password_code"
    t.datetime "reset_password_code_until"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "parent"
    t.boolean  "is_first_login"
    t.boolean  "is_deleted",                :default => false
    t.string   "google_refresh_token"
    t.string   "google_access_token"
    t.string   "google_expired_at"
  end

  add_index "users", ["admin"], :name => "index_users_on_admin", :limit => {"admin"=>nil}
  add_index "users", ["employee"], :name => "index_users_on_employee", :limit => {"employee"=>nil}
  add_index "users", ["google_access_token"], :name => "index_users_on_google_access_token", :limit => {"google_access_token"=>nil}
  add_index "users", ["is_deleted"], :name => "index_users_on_is_deleted", :limit => {"is_deleted"=>nil}
  add_index "users", ["parent"], :name => "index_users_on_parent", :limit => {"parent"=>nil}
  add_index "users", ["student"], :name => "index_users_on_student", :limit => {"student"=>nil}
  add_index "users", ["username"], :name => "index_users_on_username", :limit => {"username"=>"10"}
  add_index "users", ["username"], :name => "username_unique_index", :unique => true, :limit => {"username"=>nil}

  create_table "vehicle_additional_field_options", :force => true do |t|
    t.string   "field_option"
    t.integer  "vehicle_additional_field_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vehicles", :force => true do |t|
    t.string   "vehicle_no"
    t.integer  "main_route_id"
    t.integer  "no_of_seats"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "vehicles", ["school_id"], :name => "index_vehicles_on_school_id", :limit => {"school_id"=>nil}

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "fk_voteables", :limit => {"voteable_type"=>nil, "voteable_id"=>nil}
  add_index "votes", ["voter_id", "voter_type"], :name => "fk_voters", :limit => {"voter_type"=>nil, "voter_id"=>nil}

  create_table "wardens", :force => true do |t|
    t.integer  "hostel_id"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "wardens", ["school_id"], :name => "index_wardens_on_school_id", :limit => {"school_id"=>nil}

  create_table "weekday_sets", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_common",  :default => false
  end

  create_table "weekday_sets_weekdays", :force => true do |t|
    t.integer  "weekday_id"
    t.integer  "weekday_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weekday_sets_weekdays", ["weekday_set_id"], :name => "index_weekday_sets_weekdays_on_weekday_set_id", :limit => {"weekday_set_id"=>nil}

  create_table "weekdays", :force => true do |t|
    t.integer  "batch_id"
    t.string   "weekday"
    t.string   "name"
    t.integer  "sort_order"
    t.integer  "day_of_week"
    t.boolean  "is_deleted",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weekdays", ["batch_id"], :name => "index_weekdays_on_batch_id", :limit => {"batch_id"=>nil}

end
