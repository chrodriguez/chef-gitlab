# Gitlab 6 cookbook

This cookbook installs Gitlab 6, considering the integration with
omniauth-saml for authentication

## After installing
After installation, the administraion user  will be:

* User: admin@local.host
* Password: 5iveL!fe

This are default values from Gitlab seed

# Requierements

This cookbook depends on the following cookbooks:

```
depends          'apt', "~> 1.10.0"
depends          'mysql', "~> 3.0.4"
depends          'database', "~> 1.4.0"
depends          'rvm', "~> 0.9.0"
```

Where `rvm` sources are in this [github
repository](https://github.com/fnichol/chef-rvm)

# Vagrant 

If you are just testing Gitlab, you can run it with Vagrant and Berkshelf as
described here:

* First install **Vagrant** for your platform. [See instructions
  here](http://www.vagrantup.com/)
* Then, install **Berkshelf** gem: `gem install berkshelf`
* Finally, install vagrant's berkshelf plugin: `vagrant plugin install vagrant-berkshelf`

That's all you need

## Runing Vagrant 

After installing vagrant, berkshelf and vagrant-berkshelf plugin, run the
followin command inside the root directory of your cloned copy of this repo

```
  vagrant up
```

Wait some minutes (about 15 minutes depending on your bandwidth and machine) and your 
new Gitlab Virtual Machine will be installed from scratch:

* First vagrant will download a template Ubuntu 12.04 virtual box machine
* Then vagrant will boot up this machine
* Then, berkshelf plugin will download required cookbooks 
* Finally, chef-solo will do every step needed to install Gitlab

## When vagran finishes

In your Vagrantfile, Gitlab virtual machine will have specified its ip address. By
default is 33.33.33.10, so to test your new Gitlab instance, try accessing with
your browser to: **http://33.33.33.10/**

# Attributes

You can change default installation values by specifying your needs as json/ruby
options to chef, or directly in yours `Vagrantfile` if using vagrant.
The following are all supported attributes:

``` ruby
default[:gitlab][:user] = "git"
default[:gitlab][:home] = "/home/git"
default[:gitlab][:url] = "http://localhost"
default[:gitlab][:repository] = "https://github.com/gitlabhq/gitlabhq.git"
default[:gitlab][:revision] = "6-0-stable"
default[:gitlab][:ruby] = "2.0.0-p247"

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

default[:gitlab][:omniauth][:enabled] = false
default[:gitlab][:omniauth][:allow_single_sign_on] = false
default[:gitlab][:omniauth][:block_auto_created_users] = true
default[:gitlab][:omniauth][:providers] = []
default[:gitlab][:omniauth][:saml][:callback] = nil
default[:gitlab][:omniauth][:saml][:issuer] = nil
default[:gitlab][:omniauth][:saml][:idp_sso_target_url] = nil
default[:gitlab][:omniauth][:saml][:idp_cert_fingerprint] = nil
default[:gitlab][:omniauth][:saml][:name_identifier_format] = nil

```

## Editing 

# Recipes

There is only one: **default**. 

# Author

Author:: CeSPI - UNLP (<car@cespi.unlp.edu.ar>)
