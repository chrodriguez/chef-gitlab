pakages = %w{nginx git sudo vim build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl git-core openssh-server redis-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev python python-docutils}

pakages.each do |p|
  package p
end

group node.gitlab.user

user node.gitlab.user do
  comment "Gitlab user"
  gid node.gitlab.user
  home node.gitlab.home
  supports(manage_home: true)
  shell '/bin/bash'
end


