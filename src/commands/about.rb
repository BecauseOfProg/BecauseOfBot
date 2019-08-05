require_relative 'command'

module BoiteABois
  module Commands
    class About < Command
      CATEGORY = 'utilities'
      USAGE = 'about'
      CHANNELS = [272639973352538123]
      DESC = 'Avoir des informations sur le robot'
      LISTEN = ['public', 'private']

      def self.exec(_args, context)
        embed = BoiteABois::Utils::embed(
          title: 'À propos',
          thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: $config['illustration']),
          description: "Boîte à bois est le robot Discord du serveur de la BecauseOfProg. Il a été créé dans le but d'avoir de nombreux utilitaires, jeux ainsi que pour l'organisation intra-équipe.
Son code source est ouvert à tous : n'hésitez-pas à contribuer à son développement !

🔨 Version : #{$config['version']}
🌐 Site Internet : #{$config['website']}
💻 Mainteneur : #{$config['maintainer']['name']} (#{$config['maintainer']['link']})"
        )
        context.send_embed('', embed)
      end

    end

  end
end
