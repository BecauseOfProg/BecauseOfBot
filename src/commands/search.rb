require_relative 'command'

module BoiteABois
  module Commands
    class Search < Command
      
      CATEGORY = 'utilities'
      DESC = 'Rechercher sur la BecauseOfProg'
      USAGE = 'search'
      CHANNELS = [272639973352538123]

      # @return [Hash<Symbol,String>] Root URLs of the API
      API_URLS = {
        old: 'https://becauseofprog.fr/api/',
        api: 'https://api.becauseofprog.fr/v1/'
      }

      # @return [Hash<Symbol,String>] complete URLs to the API
      URLS = {
        article: (API_URLS[:old] + 'article/'),
        user:    (API_URLS[:api] + 'users/')
      }

      # @return [Hash<Symbol,Lambda>] All the commands available for task management
      COMMANDS = {
        article: -> (args, context) { search_article(args, context) },
        user:    -> (args, context) { search_user(args, context) }
      }

      def self.exec(args, context)
        found = false
        COMMANDS.each do |name, function|
          if args[0] == name.to_s
            found = true
            function.call(args, context) 
          end
        end
        context.send ":x: Argument inconnu : #{args[0]}" unless found
      end

      # Make a request to the API
      #
      # @param url [String] URL to call
      def self.make_request(url)
        response = Net::HTTP.get_response(URI(url))
        case response.code.to_i
        when 404 then raise BoiteABois::Exceptions::NotFound
        else JSON.parse(response.body)
        end
      end

      # ------------------------ COMMANDS ------------------------

      # Command - Search for an article
      def self.search_article(args, context)
        query = args[1].downcase
        articles = make_request(URLS[:article])['data']
        articles.select! {|_, article| article['title'].downcase.include?(query) || article['description'].downcase.include?(query)}
        if articles.length == 0
          context.send ':satellite_orbital: :x: La recherche n\'a pas abouti.'
        else
          context.send "#{articles.length} article(s) trouvés :"
          articles.each do |_, article|
            description = "#{article['description']}\n"
            article['tags'].each do |tag|
              description << "##{tag} "
            end
            context.send_embed('', Discordrb::Webhooks::Embed.new(
              title: article['title'],
              description: description,
              color: $config['color'].to_i,
              url: "https://becauseofprog.fr/blog/#{article['url']}-#{article['id']}",
              thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: article['banner']),
              author: Discordrb::Webhooks::EmbedAuthor.new(
                name: article['author']['name'],
                icon_url: article['author']['avatar']
              )
            ))
          end
        end
      end

      # Command - Search for a user
      def self.search_user(args, context)
        begin
          user = make_request(URLS[:user] + args[1])['user']
          embed = Discordrb::Webhooks::Embed.new(
            color: $config['color'].to_i,
            thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: user['picture']),
            title: "#{user['displayname']} (#{user['username']})",
            description: "#{user['description']}\n#{user['is_email_public'] ? user['email'] : ''}\n",
            fields: [
              Discordrb::Webhooks::EmbedField.new(
                name: 'Réseaux sociaux',
                value: ''
              )
            ]
          )
          user['socials'].each do |social|
            embed.fields[0].value << "#{social['name'] == 'website' ? 'Site web' : social['name'].capitalize} : #{social['value']}\n"
          end
          context.send_embed('', embed)
        rescue BoiteABois::Exceptions::NotFound
          context.send ':x: Utilisateur inconnu.'
        end
      end
    end
  end
end