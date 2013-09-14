git "#{node.gitlab.home}/gitlab-shell" do
  user node.gitlab.user
  repository node.gitlab.shell.repository
  reference node.gitlab.shell.revision
end

bash "config-gitlab-shell" do
  user node.gitlab.user
  cwd "#{node.gitlab.home}/gitlab-shell"
  code "sed 's@gitlab_url: \(.*\)@\"#{node.gitlab.url}\"@' config.yml.example > config.yml"
  not_if "test -f #{node.gitlab.home}/gitlab-shell/config.yml"
  notifies :run, "bash[install-gitlab-shell]"
end

bash "install-gitlab-shell" do
  user node.gitlab.user
  cwd "#{node.gitlab.home}/gitlab-shell"
  code "./bin/install"
  action :nothing
end

