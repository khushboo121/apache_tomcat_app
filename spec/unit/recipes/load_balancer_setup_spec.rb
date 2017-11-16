require_relative '../../spec_helper'

describe 'apache_tomcat_app::load_balancer_setup' do

  # Use an explicit subject
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it "recipe loads all the dependency files and converges successfully" do
    chef_run
  end
  
  %(apache2 tomcat7 libapache2-mod-jk openjdk-7-jdk).each do |pkg|
    it "install package #{pkg}" do
      expect(chef_run).to install_package(pkg)
    end
  end
  
  it 'creates template' do
    expect(chef_run).to create_template('/etc/libapache2-mod-jk/workers.properties').with(
    path:   "/etc/libapache2-mod-jk/workers.properties",
    source: "worker.erb",
    owner:  "root",
    group:  "root",
    mode:   0644
    )
  end
  
  %(apache2 tomcate7).each do |list|
    it "restart service #{list}" do
     expect(chef_run).to restart_service(list)
    end
  end
  
  it 'install mysql-server-5.6' do
    expect(chef_run).to install_package('mysql-server-5.6')
  end
end
