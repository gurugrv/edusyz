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

class Reminder < ActiveRecord::Base
  validates_presence_of :body,:sender,:recipient,:subject
  belongs_to :user , :foreign_key => 'sender'
  belongs_to :to_user, :class_name=>"User",:foreign_key => 'recipient'
  xss_terminate :sanitize => [ :body]
  cattr_reader :per_page
  @@per_page = 12

  def self.send_message(recipients_array,sender,end_date,elective)
    Delayed::Job.enqueue(DelayedReminderJob.new( :sender_id  => sender,
            :recipient_ids => recipients_array,
            :subject=> "Choose Elective",
            :body=> "Electives for group #{elective} are available.Please select it on or before #{end_date} "))
  end
end
