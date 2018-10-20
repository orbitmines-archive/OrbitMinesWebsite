require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OrbitMines

  class Library
    attr_reader :path

    def initialize(path)
      @path = path
    end

    LOGO = new('assets/orbitmines.png')
    ORBITMINES_ICON = new('assets/orbitmines_icon.png')

    NAV_ORBITMINES_ICON = new('assets/orbitmines250x250.png')
    NAV_DISCORD_ICON = new('assets/discord250x250.png')
    NAV_TWITTER_ICON = new('assets/twitter250x250.png')
    NAV_YOUTUBE_ICON = new('assets/youtube250x250.png')

    SURVIVAL_ICON = new('assets/survival_icon.png')
    KITPVP_ICON = new('assets/kitpvp_icon.png')
    PRISON_ICON = new('assets/prison_icon.png')
    CREATIVE_ICON = new('assets/creative_icon.png')
    SKYBLOCK_ICON = new('assets/skyblock_icon.png')
    FOG_ICON = new('assets/fog_icon.png')
    MINIGAMES_ICON = new('assets/minigames_icon.png')

    SURVIVAL = new('assets/survival.png')
    KITPVP = new('assets/kitpvp.png')
    PRISON = new('assets/prison.png')
    CREATIVE = new('assets/creative.png')
    SKYBLOCK = new('assets/skyblock.png')
    FOG = new('assets/fog.png')
    MINIGAMES = new('assets/minigames.png')

    def to_s
      @path
    end
  end

  class Color
    attr_reader :chat_color, :name, :r, :g, :b

    def initialize(chat_color, name, r, g, b)
      @chat_color = chat_color
      @name = name
      @r = r
      @g = g
      @b = b
    end

    AQUA = new('§b', 'Light Blue', 85, 255, 255)
    BLACK = new('§0', 'Black', 0, 0, 0)
    BLUE = new('§9', 'Blue', 85, 85, 255)
    FUCHSIA = new('§d', 'Pink', 255, 85, 255)
    GRAY = new('§8', 'Dark Gray', 85, 85, 85)
    GREEN = new('§2', 'Green', 0, 170, 0)
    LIME = new('§a', 'Light Green', 85, 255, 85)
    MAROON = new('§4', 'Dark Red', 170, 0, 0)
    NAVY = new('§1', 'Dark Blue', 0, 0, 170)
    ORANGE = new('§6', 'Orange', 255, 170, 0)
    PURPLE = new('§5', 'Purple', 170, 0, 170)
    RED = new('§c', 'Red', 255, 85, 85)
    SILVER = new('§7', 'Gray', 170, 170, 170)
    TEAL = new('§3', 'Cyan', 0, 170, 170)
    WHITE = new('§f', 'White', 255, 255, 255)
    YELLOW = new('§e', 'Yellow', 255, 255, 85)
  end

  class Database
    def initialize(username = 'root', password = 'password', host = '127.0.0.1', port = 3306, database = 'OrbitMines')
      # @username = username
      # @password = password
      # @host = host
      # @port = port
      # @database = database

      @client = Mysql2::Client.new(:username => username, :password => password, :host => host, :port => port, :database => database)
    end

    def get_count(table, wheres = {})
      results = @client.query("SELECT COUNT(*) AS count FROM `#{table.name}`#{wheres_to_s(wheres)}")

      return 0 if results.nil?

      results.each[0]['count']
    end

    def get(table, columns = [], wheres = {})
      results = @client.query("SELECT #{columns_to_s(columns.kind_of?(Array) ? columns : [ columns ])} FROM `#{table.name}`#{wheres_to_s(wheres)}")

      results
    end

    def sum(table, column, wheres = {})
      sum = 0

      get(table, column, wheres).each do |entry|
        sum += entry[column.name]
      end

      sum
    end

    def columns_to_s(columns)
      return "*" if columns.nil? || columns.length == 0

      columns_query = "`"

      index = 0
      columns.each do |column|
        columns_query += "`,`" if index != 0
        columns_query += column.name

        index += 1
      end

      columns_query += "`"

      columns_query
    end

    def wheres_to_s(wheres)
      return '' if wheres.nil? || wheres.length == 0

      where_query = " WHERE "

      index = 0
      wheres.each do |column, value|
        where_query += " AND " if index != 0
        where_query += "`#{column.name}`='#{value}'"

        index += 1
      end

      where_query
    end

    class Column
      attr_reader :name

      def initialize(name)
        @name = name
      end
    end

    class Table
      attr_reader :name, :columns

      def initialize(name, columns)
        @name = name
        @columns = columns
      end

      class Servers < Table
        IP = Column.new('IP')
        PORT = Column.new('Port')
        SERVER = Column.new('Server')
        STATUS = Column.new('Status')
        PLAYERS = Column.new('Players')
        MAX_PLAYERS = Column.new('MaxPlayers')
        LAST_UPDATE = Column.new('LastUpdate')
      end
      SERVERS = Servers.new('Servers', Servers::constants)

      class PlayTime < Table
        UUID = Column.new('UUID')
        KITPVP = Column.new('KITPVP')
        PRISON = Column.new('PRISON')
        CREATIVE = Column.new('CREATIVE')
        HUB = Column.new('HUB')
        SURVIVAL = Column.new('SURVIVAL')
        SKYBLOCK = Column.new('SKYBLOCK')
        FOG = Column.new('FOG')
        MINIGAMES = Column.new('MINIGAMES')
        UHSURVIVAL = Column.new('UHSurvival')
      end
      PLAY_TIME = PlayTime.new('PlayTime', PlayTime::constants)
    end
  end

  class Server
    attr_reader :name, :color, :play_time_column, :icon, :logo, :underline, :description

    def initialize(string, name, color, play_time_column, icon, logo, underline = '', description = '')
      @string = string
      @name = name
      @color = color
      @play_time_column = play_time_column
      @icon = icon
      @logo = logo
      @underline = underline
      @description = description
    end

    HUB = new('HUB', 'Hub', Color::TEAL, Database::Table::PlayTime::HUB, Library::ORBITMINES_ICON, Library::LOGO,
      'Moonbase',
      'The center of the OrbitMines Galaxy is located here.'
    )
    SURVIVAL = new('SURVIVAL', 'Survival', Color::LIME, Database::Table::PlayTime::SURVIVAL, Library::SURVIVAL_ICON, Library::SURVIVAL,
      'Colony on Planet Earth',
      'The most recent OrbitMines colony sent to Planet Earth. Where your survival is of the utmost importance.'
    )
    KITPVP = new('KITPVP', 'KitPvP', Color::RED, Database::Table::PlayTime::KITPVP, Library::KITPVP_ICON, Library::KITPVP,
      'Classified Gladiator Arena',
      'A gladiator arena setup by an unknown general and admiral in the OrbitMines fleet, located at Military Base #27.'
    )
    PRISON = new('PRISON', 'Prison', Color::MAROON, Database::Table::PlayTime::PRISON, Library::PRISON_ICON, Library::PRISON)
    CREATIVE = new('CREATIVE', 'Creative', Color::FUCHSIA, Database::Table::PlayTime::CREATIVE, Library::CREATIVE_ICON, Library::CREATIVE)
    SKYBLOCK = new('SKYBLOCK', 'SkyBlock', Color::PURPLE, Database::Table::PlayTime::SKYBLOCK, Library::SKYBLOCK_ICON, Library::SKYBLOCK)
    FOG = new('FOG', 'FoG', Color::YELLOW, Database::Table::PlayTime::FOG, Library::FOG_ICON, Library::FOG)
    MINIGAMES = new('MINIGAMES', 'MiniGames', Color::WHITE, Database::Table::PlayTime::MINIGAMES, Library::MINIGAMES_ICON, Library::MINIGAMES)

    ALL = [ HUB, SURVIVAL, KITPVP, PRISON, CREATIVE, SKYBLOCK, FOG, MINIGAMES ]

    def to_s
      @string
    end

    def self.from(string)
      ALL.each do |server|
        return server if server.to_s.eql?(string)
      end

      nil
    end
  end

  class Status
    attr_reader :string, :name, :color

    def initialize(string, name, color)
      @string = string
      @name = name
      @color = color
    end

    ONLINE = new('ONLINE', 'Online', Color::LIME)
    OFFLINE = new('OFFLINE', 'Offline', Color::RED)
    MAINTENANCE = new('MAINTENANCE', 'Maintenance', Color::FUCHSIA)
    RESTARTING = new('RESTARTING', 'Restarting', Color::GRAY)

    ALL = [ ONLINE, OFFLINE, MAINTENANCE, RESTARTING ]

    def to_s
      @string
    end

    def self.from(string)
      ALL.each do |server|
        return server if server.to_s.eql?(string)
      end

      nil
    end
  end

  module Navigation
    class Item
      attr_reader :display, :link, :icon

      def initialize(display, link, icon)
        @display = display
        @link = link
        @icon = icon
      end
    end
  end

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end

  # Initialize OrbitMines
  DATABASE = OrbitMines::Database.new
  NAVIGATION = [
      Navigation::Item.new('Discord', 'https://discordapp.com/invite/QjVGJMe', Library::NAV_DISCORD_ICON),
      Navigation::Item.new('Shop', 'https://orbitmines.buycraft.net', Library::NAV_ORBITMINES_ICON),
      Navigation::Item.new('YouTube', 'https://www.youtube.com/channel/UCjUXtvbrnqx206YnypjagVQ', Library::NAV_YOUTUBE_ICON),
      Navigation::Item.new('Twitter', 'https://www.twitter.com/OrbitMines', Library::NAV_TWITTER_ICON)
  ]
  IP = 'Hub.OrbitMines.com'
end