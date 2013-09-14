pakages = %w{git sudo vim build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl git-core openssh-server redis-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev python python-docutils}

pakages.each do |p|
  package p
end

user node.gitlab.user do
  comment "Gitlab user"
  home node.gitlab.home
  supports(manage_home: true)
end

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

