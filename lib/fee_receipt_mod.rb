module FeeReceiptMod
  
  def get_student_fee_receipt(transaction_ids,particular_wise=false,particular_id=nil)
    @fts_hash=Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    fts=FinanceTransaction.find_all_by_id(transaction_ids)
    fts.each do |ft|
      @fts_hash[ft.id]["finance_type"]=ft.finance_type
      @fts_hash[ft.id]["receipt_no"]=ft.receipt_no
      @fts_hash[ft.id]["amount"]=ft.amount
      @fts_hash[ft.id]["transaction_date"]=ft.transaction_date
      @fts_hash[ft.id]["fine_amount"]=ft.fine_amount
      @fts_hash[ft.id]["auto_fine"]=ft.auto_fine
      @fts_hash[ft.id]["payment_mode"]=ft.payment_mode
      @fts_hash[ft.id]["payment_note"]=ft.payment_note
      @fts_hash[ft.id]["reference_no"]=ft.reference_no
      @fts_hash[ft.id]["currency"] = Configuration.currency
      if ft.payee_type == "Student"
        unless ft.payee.present?
          ars=ArchivedStudent.find_by_former_id(ft.payee_id)
          ft.payee=ars
          ft.payee_type='Student'
          ft.payee_id=ars.former_id
        end
        @fts_hash[ft.id]["payee"]["type"]=ft.payee_type
        @fts_hash[ft.id]["payee"]["full_name"]=ft.payee.full_name
        @fts_hash[ft.id]["payee"]["roll_number"]=ft.payee.roll_number
        @fts_hash[ft.id]["payee"]["admission_no"]=ft.payee.admission_no
        @fts_hash[ft.id]["payee"]["full_course_name"]=ft.payee.full_course_name
      elsif ft.payee_type == "Employee"
        unless ft.payee.present?
          ae=ArchivedEmployee.find_by_former_id(ft.payee_id)
          ft.payee=ae
          ft.payee_type='Employee'
          ft.payee_id=ae.former_id
        end
        @fts_hash[ft.id]["payee"]["type"]=ft.payee_type
        @fts_hash[ft.id]["payee"]["full_name"]=ft.payee.full_name
        @fts_hash[ft.id]["payee"]["employee_number"]=ft.payee.employee_number
        @fts_hash[ft.id]["payee"]["employee_department_name"]=ft.payee.employee_department.name
      else
        @fts_hash[ft.id]["payee"]["full_name"]=ft.finance.guest_payee
      end
      case ft.finance_type
      when 'FinanceFee'
        @fts_hash[ft.id]["collection"] = ft.finance.finance_fee_collection
        @fts_hash[ft.id]["financefee"] = ft.payee.finance_fee_by_date(ft.finance.finance_fee_collection)
        @fts_hash[ft.id]["due_date"] = ft.finance.finance_fee_collection.due_date
        @fts_hash[ft.id]["fee_category"] = FinanceFeeCategory.find(ft.finance.finance_fee_collection.fee_category_id, :conditions => ["is_deleted = false"])
        
        particular_and_discount_details1(ft)
        if particular_wise==true
          particular_payment_details(ft)
        end
        ff=ft.finance
        @fts_hash[ft.id]["paid_fees"] = ff.finance_transactions.all(:conditions=>["finance_transactions.id <= ? ",ft.id])
        @fts_hash[ft.id]["done_transactions"] = done_transactions = ff.finance_transactions.all(:conditions=>["finance_transactions.id < ? ",ft.id])
        done_amount=0
        done_transactions.each do |t|
          done_amount+=t.amount
        end
        @fts_hash[ft.id]["done_amount"] = done_amount
        @fts_hash[ft.id]["remainder_amount"] = @fts_hash[ft.id]["total_payable"]-@fts_hash[ft.id]["total_discount"]-@fts_hash[ft.id]["done_amount"]
        unless particular_id.nil?
          @fts_hash[ft.id]["previous_payments"]=ff.finance_transactions.sum('finance_fee_particulars.amount',:joins=>'inner join particular_payments on particular_payments.finance_transaction_id=finance_transactions.id left outer join finance_fee_particulars on finance_fee_particulars.id=particular_payments.finance_fee_particular_id',:conditions=>["finance_transactions.id < ? and finance_fee_particulars.id =? ",ft.id,particular_id])
        end
        bal=(@fts_hash[ft.id]["total_payable"]-@fts_hash[ft.id]["total_discount"]).to_f
        days=(Date.today-ft.finance.finance_fee_collection.due_date.to_date).to_i
        auto_fine=ft.finance.finance_fee_collection.fine
        if days > 0 and auto_fine
          @fts_hash[ft.id]["fine_rule"]=auto_fine.fine_rules.find(:last, :conditions => ["fine_days <= '#{days}' and created_at <= '#{ft.finance.finance_fee_collection.created_at}'"], :order => 'fine_days ASC')
          unless particular_wise==true

            @fts_hash[ft.id]["fine_amount"]=@fts_hash[ft.id]["fine_rule"].is_amount ? @fts_hash[ft.id]["fine_rule"].fine_amount : (bal*@fts_hash[ft.id]["fine_rule"].fine_amount)/100 if @fts_hash[ft.id]["fine_rule"]
          end
        end

        
      when 'HostelFee'
        @fts_hash[ft.id]["collection"] = ft.finance.hostel_fee_collection
        ff=ft.finance
        @fts_hash[ft.id]["fine"] = ft.fine_included ? ft.fine_amount: 0.0
      when 'TransportFee'
        @fts_hash[ft.id]["collection"] = ft.finance.transport_fee_collection
        ff=ft.finance
        @fts_hash[ft.id]["fine"] = ft.fine_included ? ft.fine_amount: 0.0
      when 'InstantFee'
        @fts_hash[ft.id]["collection"] = ft.finance
        ff=ft.finance
        @fts_hash[ft.id]["instant_fee_details"] = ff.instant_fee_details
      else
        return
      end
    end
  end

  def particular_payment_details(ft)
    @fts_hash[ft.id]["particular_payments"]=ft.particular_payments.all(:select=>'finance_fee_particulars.id as particular_id,finance_fee_particulars.name as particular_name,finance_fee_particulars.amount as particular_amount,particular_payments.id as payment_id,particular_payments.amount as payment_amount,particular_discounts.id discount_id,particular_discounts.discount as payment_discount',:joins=>'left outer join particular_discounts on particular_discounts.particular_payment_id=particular_payments.id left outer join finance_fee_particulars on finance_fee_particulars.id=particular_payments.finance_fee_particular_id')
  end

  def previous_payments(ftid,pid)
    ft=FinanceTransaction.find ftid
    ff=ft.finance
    payments=ff.finance_transactions.sum('particular_payments.amount',:joins=>'inner join particular_payments on particular_payments.finance_transaction_id=finance_transactions.id left outer join finance_fee_particulars on finance_fee_particulars.id=particular_payments.finance_fee_particular_id',:conditions=>["finance_transactions.id < ? and finance_fee_particulars.id =? ",ft.id,pid])
    payments
  end

  def particular_and_discount_details1(ft)
    @fts_hash[ft.id]["fee_particulars"] = ft.finance.finance_fee_collection.finance_fee_particulars.all(:conditions => "batch_id=#{ft.finance.batch_id}").select { |par| (par.receiver_type=='Student' and par.receiver_id==ft.payee_id)? par.receiver=ft.payee : par.receiver;(par.receiver.present?) and (par.receiver==ft.payee or par.receiver==ft.finance.student_category or par.receiver==ft.finance.batch) }
    @fts_hash[ft.id]["categorized_particulars"]=@fts_hash[ft.id]["fee_particulars"].group_by(&:receiver_type)
    @fts_hash[ft.id]["discounts"] = ft.finance.finance_fee_collection.fee_discounts.all(:conditions => "batch_id=#{ft.finance.batch_id}").select { |par| (par.receiver.present?) and ((par.receiver==ft.finance.student or par.receiver==ft.finance.student_category or par.receiver==ft.finance.batch) and (par.master_receiver_type!='FinanceFeeParticular' or (par.master_receiver_type=='FinanceFeeParticular' and (par.master_receiver.receiver.present? and @fts_hash[ft.id]["fee_particulars"].collect(&:id).include? par.master_receiver_id) and (par.master_receiver.receiver==ft.finance.student or par.master_receiver.receiver==ft.finance.student_category or par.master_receiver.receiver==ft.finance.batch)))) }
    @fts_hash[ft.id]["categorized_discounts"]=@fts_hash[ft.id]["discounts"].group_by(&:master_receiver_type)
    @fts_hash[ft.id]["total_discounts"]= 0
    @fts_hash[ft.id]["total_payable"] = @fts_hash[ft.id]["fee_particulars"].map { |s| s.amount }.sum.to_f
    @fts_hash[ft.id]["total_discount"] = @fts_hash[ft.id]["discounts"].map { |d| d.master_receiver_type=='FinanceFeeParticular' ? (d.master_receiver.amount * d.discount.to_f/(d.is_amount? ? d.master_receiver.amount : 100)) : @fts_hash[ft.id]["total_payable"] * d.discount.to_f/(d.is_amount? ? @fts_hash[ft.id]["total_payable"] : 100) }.sum.to_f unless @fts_hash[ft.id]["discounts"].nil?
  end

  def payer_sql
    conditions = []
    
    payer="(select p.id payer_id,concat(p.first_name,' ',p.middle_name,' ',p.last_name) payer_name,batches.id batchid,concat(courses.course_name,' - ',batches.name) payer_batch_dept,p.admission_no payer_no,'Student' payer_type,'Student' payer_type_info from students p inner join batches on batches.id=p.batch_id inner join courses on courses.id=batches.course_id )"
    payer+=" UNION ALL (select p.former_id payer_id,concat(p.first_name,' ',p.middle_name,' ',p.last_name) payer_name,batches.id batchid,concat(courses.course_name,' - ',batches.name) payer_batch_dept,p.admission_no payer_no,'Student' payer_type,'Archived Student' payer_type_info from archived_students p inner join batches on batches.id=p.batch_id inner join courses on courses.id=batches.course_id)"
    payer+=" UNION ALL (select p.id payer_id,concat(p.first_name,' ',p.middle_name,' ',p.last_name) payer_name,NULL batchid,employee_departments.name payer_batch_dept,p.employee_number payer_no,'Employee' payer_type,'Employee' payer_type_info from employees p inner join employee_departments on employee_departments.id=p.employee_department_id )"
    payer+=" UNION ALL (select p.former_id payer_id,concat(p.first_name,' ',p.middle_name,' ',p.last_name) payer_name,NULL batchid,employee_departments.name payer_batch_dept,p.employee_number payer_no,'Employee' payer_type,'Archived Employee' payer_type_info from archived_employees p inner join employee_departments on employee_departments.id=p.employee_department_id)"
    payer+=" UNION ALL (select p.id payer_id,p.guest_payee payer_name,NULL batchid,NULL payer_batch_dept,NULL payer_no,'Guest' payer_type,'Guest' payer_type_info from instant_fees p where p.guest_payee IS NOT NULL )"
    payer
  end

  def fee_sql(query=nil)
    unless query.nil?
      havings = ["having collection_name LIKE '%#{query}%'"]
    else
      havings = []
    end
    conditions=[]
    
    fee="(select fc.name collection_name,cf.id fin_id,'FinanceFee' fin_type,cf.fee_collection_id collection_id from finance_fees cf inner join finance_fee_collections fc on fc.id=cf.fee_collection_id group by cf.id #{havings})"
    fee+=" UNION ALL (select  hc.name collection_name,cf.id fin_id,'HostelFee' fin_type,cf.hostel_fee_collection_id collection_id from hostel_fees cf inner join hostel_fee_collections hc on hc.id=cf.hostel_fee_collection_id group by cf.id #{havings})" if (FedenaPlugin.can_access_plugin?("fedena_hostel"))
    fee+=" UNION ALL (select tc.name collection_name,cf.id fin_id,'TransportFee' fin_type,cf.transport_fee_collection_id collection_id from transport_fees cf inner join transport_fee_collections tc on tc.id=cf.transport_fee_collection_id group by cf.id #{havings})" if (FedenaPlugin.can_access_plugin?("fedena_transport"))
    fee+=" UNION ALL (select ic.name collection_name,cf.id fin_id,'InstantFee' fin_type,cf.instant_fee_category_id collection_id from instant_fees cf inner join instant_fee_categories ic on ic.id=cf.instant_fee_category_id where ic.name IS NOT NULL group by cf.id #{havings})" if (FedenaPlugin.can_access_plugin?("fedena_instant_fee"))
    fee+=" UNION ALL (select cf.custom_category collection_name,cf.id fin_id,'InstantFee' fin_type,NULL collection_id from instant_fees cf where cf.custom_category IS NOT NULL group by cf.id #{havings})" if (FedenaPlugin.can_access_plugin?("fedena_instant_fee"))
    fee
  end
  
  def fetched_fee_receipts(*args)
    FinanceTransaction.scoped(:select=>"finance_transactions.id ftid,finance_transactions.trans_type,finance_transactions.finance_type fin_type,finance_transactions.reference_no,finance_transactions.receipt_no,finance_transactions.payment_mode,finance_transactions.transaction_date,finance_transactions.amount,u.batchid,u.payer_type_info,u.payer_name,f.collection_id,u.payer_type,u.payer_no,u.payer_id,u.payer_batch_dept,concat(c.first_name,' ',c.last_name) full_user_name,c.username uname,c.id user_id, f.collection_name,f.fin_id",:joins=>"inner join (#{fee_sql}) f on finance_transactions.finance_id=f.fin_id and finance_transactions.finance_type=f.fin_type left outer join (#{payer_sql}) u on (ifnull(finance_transactions.payee_id,finance_transactions.finance_id)=u.payer_id) and ifnull(finance_transactions.payee_type,'Guest')=u.payer_type left outer join users c on finance_transactions.user_id = c.id",:conditions=>["((finance_type IN ('TransportFee','HostelFee','FinanceFee','InstantFee')))"],:order=>"finance_transactions.id desc")
  end
end
