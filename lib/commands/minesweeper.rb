require_relative 'command'

module BoiteABois
  module Commands
    class Minesweeper < Command

      CATEGORY = 'games'
      USAGE = 'minesweeper [width] [height] [mines]'
      DESC = 'Générer une grille de démineur (par défaut 9x9 avec 10 mines)'
      CHANNELS = [541314079298551819]

      def self.exec(args, context)
        width, height, mines = args.map {|x| x.to_i}
        if width.nil?
          width = height = 9
          mines = 10
        end
        if mines <= 0
          context.send ':x: Veuillez mettre au moins une mine.'
          return
        elsif mines >= width * height
          context.send '💥 Il y a trop de mines ! Réduisez leur nombre.'
          return
        end
        begin
          context.send generate(width, height, mines)
        rescue Discordrb::Errors::MessageTooLong
          context.send 'La grille est trop volumineuse. Essayez de réduire sa taille.'
        end
      end

      def self.generate(width = 9, height = 9, mines = 10)
        # Defining emojis
        emojis = ['◻', ':one:', ':two:', ':three:', ':four:', ':five:', ':six:', ':seven:', ':eight:', '💣']
      
        # Generating the base table
        table = Array.new(height)
        table.each_index do |i|
          table[i] = Array.new(width)
        end
      
        # Adding mines 
        mines.times do
          mine_location = [rand(width - 1), rand(height - 1)]
          cell = table[mine_location[0]][mine_location[1]]
          redo if cell == emojis[9]
          table[mine_location[0]][mine_location[1]] = emojis[9]
        end
      
        # Generating numbers around mines
        height.times do |height|
          width.times do |width|
            if table[height][width] == emojis[9]
              next
            end
            mines = 0
      
            (-1..1).each do |i|
              (-1..1).each do |j|
                next if i == 0 && j == 0
                neighbor_cell_height = table[height + i]
                unless neighbor_cell_height == Array.new(width) || neighbor_cell_height.nil?
                  neighbor_cell = neighbor_cell_height[width + j]
                  mines += 1 if neighbor_cell == emojis[9]
                end
              end
            end
      
            table[height][width] = emojis[mines]
          end
        end
      
        # Generating the Discord style output
        result = ''
      
        table.each do |a|
          a.each do |x| 
            result += "||#{x}||"
          end
          result += "\n"
        end
        result
      end
    end
  end
end