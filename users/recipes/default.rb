group 'opsworks'

params = {
  :name   => 'brandon',
  :public_key => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQjS/bwlqh204E4wjV6gZucJkO6qKduQahO41yVoG2vgzXIa3kUZpuJr9k4hPEOcrdQUsROoNJQb1X6gdnmFw2/uk7EQ66+U4CXOGeA6olPSFL31qpb76vJSXTlTyDNovtq9yCJFQj9cZwV6oI+I39phZjT3sdnLHRPem5/BuME8xngG222TJNj1N2c13B+25jThrBhFdf2TFpxcbk8X6FmKeVmF7YuG1NQJLzvk+d+Ag15ewmfXL7w/x2trpQTRM8aJDmQPyAktSMpmcui9wISHyGDmIkGwqhybTUHwjaBJ3SsRnIRlf9fCvdwVzAinUxDnCCF8zsftVVj+h1Yaax'
}

user params[:name] do
  action :create
  comment "OpsWorks user #{params[:name]}"
  gid 'opsworks'
  home "/home/#{params[:name]}"
  supports :manage_home => true
  shell '/bin/bash'
end
directory "/home/#{params[:name]}/.ssh" do
  owner params[:name]
  group 'opsworks'
  mode 0700
end

template "/home/#{params[:name]}/.ssh/authorized_keys" do
  cookbook 'ssh_users'
  source 'authorized_keys.erb'
  owner params[:name]
  group 'opsworks'
  variables(:public_key => params[:public_key])
  only_if do
    File.exists?("/home/#{params[:name]}/.ssh")
  end
end
# existing_ssh_users = load_existing_ssh_users
# existing_ssh_users.each do |id, name|
  # unless node[:ssh_users][id]
    # teardown_user(name)
  # end
# end
#
# node[:ssh_users].each do |id, ssh_user|
  # if (existing_name = existing_ssh_users[id])
    # unless existing_name == ssh_user[:name]
      # rename_user(existing_name, ssh_user[:name])
    # end
  # else
    # setup_user(ssh_user.update(:uid => id))
  # end
  # set_public_key(ssh_user)
# end

template '/etc/sudoers' do
  backup false
  source 'sudoers.erb'
  owner 'root'
  group 'root'
  mode 0440
  variables :sudoers => [{:name => 'brandon'}]
end


