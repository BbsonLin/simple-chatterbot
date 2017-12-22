if defined?(Slackistrano::Messaging)
   module Slackistrano
     class CustomMessaging < Messaging::Base

       # Send failed message to #ops. Send all other messages to default channels.
       # The #ops channel must exist prior.
       def channels_for(action)
         if action == :failed
           super
         else
           super
         end
       end

       # Suppress updating message.
       def payload_for_updating
         nil
       end

       # Suppress reverting message.
       def payload_for_reverting
         nil
       end

       # Fancy updated message.
       # See https://api.slack.com/docs/message-attachments
       def payload_for_updated
         {
           attachments: [{
             color: 'good',
             title: 'Application ' + application + ' Deployed :ok_hand::heart:',
             fields: [{
               title: 'Environment',
               value: stage,
               short: true
             }, {
               title: 'Branch',
               value: branch,
               short: true
             }, {
               title: 'Deployer',
               value: deployer,
               short: true
             }, {
               title: 'Time',
               value: elapsed_time,
               short: true
             }],
             fallback: super[:text]
           }]
         }
       end

       # Default reverted message.  Alternatively simply do not redefine this
       # method.
       def payload_for_reverted
         {
           attachments: [{
             color: '#5BD9E3',
             title: 'Application ' + application + ' Rollback :back::thinking_face:',
             fields: [{
               title: 'Environment',
               value: stage,
               short: true
             }, {
               title: 'Branch',
               value: branch,
               short: true
             }, {
               title: 'Deployer',
               value: deployer,
               short: true
             }, {
               title: 'Time',
               value: elapsed_time,
               short: true
             }],
             fallback: super[:text]
           }]
         }
       end

       # Slightly tweaked failed message.
       # See https://api.slack.com/docs/message-formatting
       def payload_for_failed
         {
           attachments: [{
             color: 'danger',
             title: 'Application ' + application + ' Deploy Failed :scream_cat::bangbang:',
             fields: [{
               title: 'Environment',
               value: stage,
               short: true
             }, {
               title: 'Branch',
               value: branch,
               short: true
             }, {
               title: 'Deployer',
               value: deployer,
               short: true
             }, {
               title: 'Time',
               value: elapsed_time,
               short: true
             }],
             fallback: super[:text]
           }]
         }
       end

       # Override the deployer helper to pull the best name available (git, password file, env vars).
       # See https://github.com/phallstrom/slackistrano/blob/master/lib/slackistrano/messaging/helpers.rb
       def deployer
         name = `git config user.name`.strip
         name = nil if name.empty?
         name ||= Etc.getpwnam(ENV['USER']).gecos || ENV['USER'] || ENV['USERNAME']
         name
       end
     end
   end
end