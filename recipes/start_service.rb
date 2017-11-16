# this recipe start apache2, tomcat7, mysql service

service_list = node['apache_tomcat_app']['service_list']

service_list.each do |list|
  service list do
    action: start
  end
end