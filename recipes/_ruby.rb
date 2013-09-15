node.set['rvm']['user_installs'] = [
  { 'user'    => node.gitlab.user,
    'default_ruby'  => node.gitlab.ruby,
    'global'  => node.gitlab.ruby,
    'user_gems'    => [
      { 'name'    => 'bundler' },
      { 'name'    => 'rake' },
      { 'name'    => 'charlock_holmes', 
        'version' => '0.6.9.4'  
      },
     ]
  }
]
bash "add_sudo" do
  code <<-EOS
    cp /etc/sudoers /tmp/sudoers.bak
    echo '#{node.gitlab.user} ALL=NOPASSWD: ALL' >> /etc/sudoers
  EOS
end

include_recipe "rvm::user"

bash "add_sudo" do
  code <<-EOS
    cp -f /tmp/sudoers.bak /etc/sudoers
    chmod 440 /etc/sudoers
  EOS
end
