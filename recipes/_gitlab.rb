git "#{node.gitlab.home}/gitlab" do
  user node.gitlab.user
  repository node.gitlab.repository
  reference node.gitlab.revision
end

%w{log tmp tmp/pids tmp/sockets public/uploads}.each do |dir|
  directory "#{node.gitlab.home}/gitlab/#{dir}" do
    owner node.gitlab.user
    group node.gitlab.user
    mode 0755
    recursive true
  end
end

directory "#{node.gitlab.home}/gitlab-satellites" do
  owner node.gitlab.user
  group node.gitlab.user
end

%w{repositories repositories/root}.each do |dir|
  directory "#{node.gitlab.home}/#{dir}" do
    owner node.gitlab.user
    group node.gitlab.user
    mode 0770
    recursive true
  end
end

template "#{node.gitlab.home}/gitlab/config/gitlab.yml" do
  source "gitlab.yml.erb"
  owner node.gitlab.user
  notifies :restart, "service[gitlab]"
end

template "#{node.gitlab.home}/gitlab/config/database.yml" do
  source "database.yml.erb"
  owner node.gitlab.user
  notifies :restart, "service[gitlab]"
end

template "#{node.gitlab.home}/gitlab/config/unicorn.rb" do
  user node.gitlab.user
  source "unicorn.rb.erb"
end

bash "configure-git" do
  code <<-EOS
    sudo -u #{node.gitlab.user} -H git config --global user.name "GitLab"
    sudo -u #{node.gitlab.user} -H git config --global user.email "#{node.gitlab.mail_from}"
    sudo -u #{node.gitlab.user} -H git config --global core.autocrlf input
  EOS
end

if node.gitlab.omniauth.enabled and node.gitlab.omniauth.saml
  bash "add_omniauth_saml" do
    code "echo gem '\"omniauth-saml\"' >> #{node.gitlab.home}/gitlab/Gemfile"
    not_if "grep -q omniauth-saml #{node.gitlab.home}/gitlab/Gemfile"
  end
  template "#{node.gitlab.home}/gitlab/config/initializers/devise.rb" do
    user node.gitlab.user
    notifies :restart, "service[gitlab]"
  end

end

rvm_shell "initialize-gitlab" do
  user node.gitlab.user
  cwd "#{node.gitlab.home}/gitlab"
  code <<-EOS
    bundle install --no-deployment --without development test postgres aws
  EOS
end

rvm_shell "initialize-gitlab" do
  user node.gitlab.user
  cwd "#{node.gitlab.home}/gitlab"
  code <<-EOS
    bundle exec rake gitlab:setup RAILS_ENV=production force=yes
    bundle exec rake assets:precompile RAILS_ENV=production
  EOS
  not_if "test -f /etc/init.d/gitlab"
end

template "/etc/init.d/gitlab" do
  source "init.d-gitlab.erb"
  mode 0755
end

service "gitlab" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
    only_if "test -x /etc/init.d/gitlab"
end

template "/etc/nginx/sites-available/gitlab" do
  source "nginx-gitlab.erb" 
end

link "/etc/nginx/sites-enabled/gitlab" do
  to "/etc/nginx/sites-available/gitlab"
  notifies :restart, "service[nginx]"
end

bash "remove_nginx_default" do
  code "rm -f /etc/nginx/sites-available/default"
  only_if "test -l /etc/nginx/sites-available/default"
end

service "nginx" do
  action :nothing
end
