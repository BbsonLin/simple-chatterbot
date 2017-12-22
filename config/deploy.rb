set :application, 'smatech-2017-rps'
set :keep_releases, 3
set :repo_url, 'git@bitbucket.org:aiwill/smatech-2017-rps.git'
set :deploy_to, '/var/www/smatech-2017-rps'
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :slackistrano, {
  klass: Slackistrano::CustomMessaging,
  channel: '#smatech',
  webhook: 'https://hooks.slack.com/services/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'
}

# Custom Variables
set :image_name, 'rps'
set :yarn_image, 'yarn'
set :container_name, 'rps'
set :docker, 'docker'
set :docker_compose, 'docker-compose'

# if ENV['BASTION']
#   require 'net/ssh/proxy/command'
#   bastion_host = 'your.bastion.machine'
#   bastion_user = 'your_ssh_account'
#   bastion_port = 22
#   ssh_command = "ssh -p #{bastion_port} #{bastion_user}@#{bastion_host} -W %h:%p"
#   set :ssh_options, proxy: Net::SSH::Proxy::Command.new(ssh_command)
# end

namespace :deploy do

  desc 'Running a docker containers for this project.'
  task :dockerize do
    on roles(:all) do
      previous = capture("ls -t1 #{releases_path} | sed -n '2p'").to_s.strip
      execute "cd #{release_path} && #{fetch(:docker)} build --rm -t #{fetch(:image_name)} ."
      # execute "cd #{release_path} && #{fetch(:docker)} build --rm -t #{fetch(:yarn_image)} -f Dockerfile.yarn ."
      execute "cd #{releases_path}/#{previous} && #{fetch(:docker_compose)} down"
      # execute "cd #{releases_path}/#{previous} && #{fetch(:docker_compose)} -f build.yml down"
      # execute "cd #{release_path} && #{fetch(:docker_compose)} -f build.yml up"
      execute "cd #{release_path} && #{fetch(:docker_compose)} up -d"
    end
  end

  desc 'Kill the application docker container.'
  task :kill_docker do
    on roles(:all) do
      execute "#{fetch(:docker)} stop #{fetch(:container_name)}; docker rm -f #{fetch(:container_name)}"
    end
  end

  desc 'Show deployed revision'
  task :revision do
    on roles(:web) do
      execute "cat #{current_path}/REVISION"
    end
  end

  desc 'Show docker-compose log.'
  task :log do
    on roles(:all) do
      execute "cd #{release_path} && #{fetch(:docker_compose)} logs -f"
    end
  end

  after 'deploy:published', 'deploy:dockerize'

end
