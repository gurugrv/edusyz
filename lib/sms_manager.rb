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

# Configure your SMS API settings
require 'net/http'
require 'yaml'
require 'translator'

class SmsManager
  attr_accessor :recipients, :message

  def initialize(message, recipients)
    @recipients = recipients.map{|r| r.gsub(' ','')}
    @message = CGI::escape message
    @config = SmsSetting.get_sms_config
    unless @config.blank?
      @sendername = @config['sms_settings']['sendername']
      @sms_url = @config['sms_settings']['host_url']
      @username = @config['sms_settings']['username']
      @password = @config['sms_settings']['password']
      @success_code = @config['sms_settings']['success_code']
      @username_mapping = @config['parameter_mappings']['username']
      @username_mapping ||= 'username'
      @password_mapping = @config['parameter_mappings']['password']
      @password_mapping ||= 'password'
      @phone_mapping = @config['parameter_mappings']['phone']
      @phone_mapping ||= 'phone'
      @sender_mapping = @config['parameter_mappings']['sendername']
      @sender_mapping ||= 'sendername'
      @message_mapping = @config['parameter_mappings']['message']
      @message_mapping ||= 'message'
      unless @config['additional_parameters'].blank?
        @additional_param = ""
        @config['additional_parameters'].split(',').each do |param|
          @additional_param += "&#{param}"
        end
      end
    end
  end

  def perform
    message_log = SmsMessage.new(:body=> @message)
    message_log.save
    if @config.present?
      encoded_message = @message
      request = "#{@sms_url}?#{@username_mapping}=#{@username}&#{@password_mapping}=#{@password}&#{@sender_mapping}=#{@sendername}&#{@message_mapping}=#{encoded_message}#{@additional_param}&#{@phone_mapping}="
      ms_present = MultiSchool rescue false
      @recipients.each do |recipient|
        if ms_present
          package_used = MultiSchool.current_school.assigned_packages.first(:conditions=>{:is_using=>true},:include=>:sms_package)
          unless package_used.nil?
            numbers_to_send = recipient.split(",").count
            size_limit = package_used.sms_package.character_limit.present? ? package_used.sms_package.character_limit : 160
            message_size = ((CGI.unescape(encoded_message).length).to_f/(size_limit).to_f).ceil
            required_msg_count = (numbers_to_send * message_size)
            if (package_used.sms_count.nil? and package_used.validity.nil?)
              can_send_sms = true
            elsif package_used.sms_count.nil?
              can_send_sms = (package_used.validity.to_date >= Date.today)
            elsif package_used.validity.nil?
              can_send_sms = (package_used.sms_count.to_i >= ((package_used.sms_used.to_i)+required_msg_count))
            else
              can_send_sms = ((package_used.sms_count.to_i >= ((package_used.sms_used.to_i)+required_msg_count)) and (package_used.validity.to_date >= Date.today))
            end
          else
            can_send_sms = false
          end
        else
          can_send_sms = true
        end
        if can_send_sms
          cur_request = request
          cur_request += "#{CGI.escape(recipient)}"
          begin
            uri = URI.parse(cur_request)
            http = Net::HTTP.new(uri.host, uri.port)
            if cur_request.include? "https://"
              http.use_ssl = true
              http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            end
            get_request = Net::HTTP::Get.new(uri.request_uri)
            response = http.request(get_request)
            if response.body.present?
              message_log.sms_logs.create(:mobile=>recipient,:gateway_response=>response.body)
              if @success_code.present?
                if response.body.to_s.include? @success_code
                  sms_count = Configuration.find_by_config_key("TotalSmsCount")
                  new_count = sms_count.config_value.to_i + 1
                  sms_count.update_attributes(:config_value=>new_count)
                  if ms_present
                    package_used.update_attributes(:sms_used=>(package_used.sms_used.to_i + required_msg_count))
                  end
                end
              end
            end
          rescue Timeout::Error => e
            message_log.sms_logs.create(:mobile=>recipient,:gateway_response=>e.message)
          rescue Errno::ECONNREFUSED => e
            message_log.sms_logs.create(:mobile=>recipient,:gateway_response=>e.message)
          end
        else
          message_log.sms_logs.create(:mobile=>recipient,:gateway_response=>"#{I18n.t('package_expired')}")
        end
      end
    else
      message_log.sms_logs.create(:mobile=>@recipients.join(","),:gateway_response=>"#{I18n.t('package_not_assigned')}")
    end
  end
end