require "bundler/capistrano"
set :application, "zlog"
set :repository,  "git@github.com:dinglixiang/zlog.git"
 
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, true
set :branch, "master"
default_run_options[:pty] = true
 
server "billie.happyec.org", :web, :app, :db, :primary => true
 
namespace :deploy do
 
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, :roles => :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end
 
  desc "things I need to do after deploy:setup"
  task :setup_config, :roles => :app do
    run "#{try_sudo} ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    run "#{try_sudo} ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}. create db"
  end
  after "deploy:setup", "deploy:setup_config"
 
  task :symlink_config, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"
 
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
