require_relative 'command'

module BoiteABois
  module Commands
    class Weather < Command

      USAGE = 'weather <location>'
      DESC = 'Obtenir la météo à un endroit précis'

      def self.exec(args, context)
        begin
          data = BoiteABois::Constants::WEATHER_API.current(args[0])
          context.send "￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ #{data.city.name} :flag_#{data.city.country.downcase}:
  ￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶#{data.weather_conditions.emoji} #{data.weather_conditions.description.capitalize}

:thermometer: Température : #{data.weather_conditions.temperature}°C
:droplet: Humidité : #{data.weather_conditions.humidity}%
:cloud: Nuages : #{data.weather_conditions.clouds}%
:dash: Vent : #{(data.weather_conditions.wind[:speed] * 3.6).ceil(1)} km/h"
        rescue OpenWeatherMap::Exceptions::UnknownLocation
          context.send ':satellite_orbital: :x: Cette localisation est inconnue.'
        end
      end

    end
  end
end