node.set['rbenv']['user_installs'] = [
  { 'user'    => node.gitlab.user,
    'rubies'  => [ node.gitlab.ruby ],
    'global'  => node.gitlab.ruby,
    'gems'    => {
      node.gitlab.ruby  => [
        { 'name'    => 'bundler' },
        { 'name'    => 'rake' }
      ]
    }
  }
]
include_recipe "ruby_build"
include_recipe "rbenv::user"
