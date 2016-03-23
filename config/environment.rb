# Load the Rails application.
require File.expand_path('../application', __FILE__)
require 'carrierwave/orm/activerecord'

# Initialize the Rails application.
Rails.application.initialize!

# get Sendgrid credentials from ENV variable
credentials = host = username = password = ''
if !ENV['VCAP_SERVICES'].blank?
  JSON.parse(ENV['VCAP_SERVICES']).each do |k,v|
    if !k.scan("sendgrid").blank?
      credentials = v.first.select {|k1,v1| k1 == "credentials"}["credentials"]
      host = credentials["hostname"]
      username = credentials["username"]
      password = credentials["password"]
    end
  end
end

# overwrite ActionMailer settings to send through SendGrid servers
ActionMailer::Base.smtp_settings = {
    :address        => host,
    :port           => '587',
    :authentication => :plain,
    :user_name      => username,
    :password       => password,
    :domain         => 'cfapps.io',
    :enable_starttls_auto => true
}
