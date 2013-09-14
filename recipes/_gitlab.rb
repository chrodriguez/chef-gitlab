git "#{node.gitlab.home}/gitlab" do
  user node.gitlab.user
  repository node.gitlab.repository
  reference node.gitlab.revision
end

%w{log tmp tmp/pids tmp/sockets public/uploads}.each do |dir|
  directory "#{node.gitlab.home}/gitlab/#{dir}" do
    owner node.gitlab.user
    mode 0700
    recursive true
  end
end

directory "#{node.gitlab.home}/gitlab-satellites" do
  owner node.gitlab.user
end

template "#{node.gitlab.home}/gitlab/config/gitlab.yml" do
  source "gitlab.yml.erb"
  owner node.gitlab.user
end

template "#{node.gitlab.home}/gitlab/config/database.yml" do
  source "database.yml.erb"
  owner node.gitlab.user
end

bash "unicorn-config" do
  user node.gitlab.user
  cwd "#{node.gitlab.home}/gitlab"
  code "cp config/unicorn.rb.example config/unicorn.rb"
  not_if "test -f #{node.gitlab.home}/gitlab/config/unicorn.rb"
end

bash "configure-git" do
  code <<-EOS
    sudo -u #{node.gitlab.user} -H git config --global user.name "GitLab"
    sudo -u #{node.gitlab.user} -H git config --global user.email "#{node.gitlab.mail_from}"
    sudo -u #{node.gitlab.user} -H git config --global core.autocrlf input
  EOS
end

