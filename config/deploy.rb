set :application, 'chatbot'
set :keep_releases, 3
set :repo_url, 'https://github.com/BbsonLin/simple-chatterbot.git'
set :deploy_to, '/var/www/chatbot'
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :slackistrano, {
  klass: Slackistrano::CustomMessaging,
  channel: '#smatech',
  webhook: 'https://hooks.slack.com/services/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'
}

# Custom Variables
set :image_name, 'chatbot'
set :container_name, 'chatbot'
set :docker, 'docker'
set :docker_compose, 'docker-compose'

namespace :deploy do

  desc 'Running a docker containers for this project.'
  task :dockerize do
    on roles(:all) do
      previous = capture("ls -t1 #{releases_path} | sed -n '2p'").to_s.strip
        execute "cd #{release_path} && #{fetch(:docker)} build --rm -t #{fetch(:image_name)} ."
        execute "cd #{releases_path}/#{previous} && #{fetch(:docker_compose)} down"
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
