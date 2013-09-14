default[:gitlab][:user] = "git"
default[:gitlab][:home] = "/home/git"
default[:gitlab][:url] = "http://localhost"
default[:gitlab][:repository] = "https://github.com/gitlabhq/gitlabhq.git"
default[:gitlab][:revision] = "6-0-stable"

# Gitlab shell
default[:gitlab][:shell][:repository] = "https://github.com/gitlabhq/gitlab-shell.git"
default[:gitlab][:shell][:revision] = "v1.7.1"

# Gitlab database settings
default[:gitlab][:database][:host] = "localhost"
default[:gitlab][:database][:name] = "gitlab"
default[:gitlab][:database][:user] = "gitlab"
default[:gitlab][:database][:password] = "gitlab"
default[:gitlab][:database][:superuser][:user] = nil
default[:gitlab][:database][:superuser][:password] = nil

# Customizations
default[:gitlab][:mail_from] = "gitlab@localhost"
default[:gitlab][:support_email] = "support@localhost"
default[:gitlab][:default_projects_limit] = 10
default[:gitlab][:default_projects_features] = {
      issues: true,
      merge_requests: true,
      wiki: true,
      wall: false,
      snippets: false
}
