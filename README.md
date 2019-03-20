# Boite à bois

Another idea from Exybore.

Features:

- Play games such as minesweeper or "pendu"
- Get the current weather and weather forecast for any city in the world
- Send very nice GIF

## Requirements

- Ruby 2.1+
- [Discordrb gem](https://rubygems.org/gems/discordrb/versions/3.2.1)
- [JSON gem](https://rubygems.org/gems/json/versions/2.1.0)
- [OpenWeatherMap gem](https://rubygems.org/gems/openweathermap)

## First start

To use it, you must setup config.json (there is example with the samples).
When it's configured, you can start the bot with a

```ruby
ruby run.rb
```

After that, the bot is ready and you can add it to your guild ([Guide](https://discordapp.com/developers/docs/topics/oauth2#bot-authorization-flow))

## Creating a new command

To create a new command, you only must create a file in /lib/commands/ of the name of your command.
In this file, you have to require command.rb and set the namespace to BecauseOfProg::Commands.
The class should inherit from Command.
When you add a new command, you must restart the bot.
Here is an example (example.rb):

```ruby
require_relative 'command'

module BoiteABois
  module Commands
    class Example < Command

      USAGE = 'example' # Command usage
      DESC = 'Description' # Command description
      #ALIAS = 'another_command' # Alias to another command
      #SHOW = true # Visibility in the command list

      def self.exec(args, msg)
        # msg is an instance of Discordrb::Message
        # args is an array of arguments
      end

    end
  end
end
```

## Credits

- Library: [DiscordRB](https://github.com/meew0/discordrb)
- Main developers: [Whaxion](https://github.com/whaxion) (architecture) and [Exybore](https://github.com/exybore) (commands)
- License: [GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/)
