# default recipe 

service_list = ['apache_tomcat_app']['service_list']

service_list.each do |services|
  service services do
    action :start
  end
end

