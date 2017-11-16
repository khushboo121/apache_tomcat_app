# default recipe 

# Installing Apache Package
package 'Install Apache' do
  case node[:platform]
  when 'redhat', 'centos'
    package_name 'httpd'
  when 'ubuntu', 'debian'
    package_name 'apache2'
  end
end

#installing tomcate,mod_jk,jdk
package %w(tomcat7 libapache2-mod-jk openjdk-7-jdk)

#After installing setting up the java path in  /home/ubuntu/.bashrc

ruby_block 'Set JAVA_HOME in /home/ubuntu/.bashrc' do
    block do
      file = Chef::Util::FileEdit.new('/home/ubuntu/.bashrc')
      file.insert_line_if_no_match(/^JAVA_HOME=/,"JAVA_HOME=\"/usr/lib/jvm/java-7-openjdk-amd64\"")
      file.write_file
    end
  end

# creating two tomcat server
bash 'Execute bash script'
   code <<-EOH
     cp -a /etc/tomcat7 /opt/server1
     cp -a /etc/tomcat7 /opt/server2      
   EOH
end

#Uncommenting the connector port and also updating connector port for protocol apj

edit_file("/etc/server1/server.xml", "protocol=\"AJP/1.3\"", "    <connector port=\"8108\" protocol=\"AJP/1.3\" redirectPort=\"8443\"></connector>")
edit_file("/etc/server2/server.xml", "protocol=\"AJP/1.3\"", "    <connector port=\"8109\" protocol=\"AJP/1.3\" redirectPort=\"8443\"></connector>")

def edit_file(filename, regex, line)
  ruby_block "editing #{filename}" do
    block do
      file = Chef::Util::FileEdit.new(filename)
      file.search_file_replace_line(regex, line)
      file.write_file
    end
  end
end


# Creating worker.property file
template '/etc/libapache2-mod-jk/workers.properties' do
  path '/etc/libapache2-mod-jk/workers.properties'
  source 'worker.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Configure Apache Web Server to forward requests
ruby_block 'Configure Apache Web Server to forward requests' do
    block do
      file = Chef::Util::FileEdit.new('/etc/apache2/sites-enabled/000-default.conf')
      file.insert_line_if_no_match(/^JkMount \/status status/,'JkMount /status status')
      file.insert_line_if_no_match(/^JkMount \/* loadbalancer/,'JkMount /* loadbalancer')
      file.write_file
    end
end

service_list = node['apache_tomcat_app'] ['service_list']

service_list.each do |services|
  service services do 
    action: restart
  end 
end  

# installing mysql server 
package 'mysql-server-5.6'
