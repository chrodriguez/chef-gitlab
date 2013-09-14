include_recipe "database::mysql"

connection = {
  host: node.gitlab.database.host,
  username: (node.gitlab.database.superuser.user || 'root'),
  password: (node.gitlab.database.superuser.password ||  node.mysql.server_root_password)
}


mysql_database node.gitlab.database.name do
  connection connection
  action :create
end


mysql_database_user  node.gitlab.database.user do
  connection connection
  password node.gitlab.database.password
  host node.gitlab.database.host
  database_name node.gitlab.database.name
  privileges [:all]
  action [:create, :grant]
end

