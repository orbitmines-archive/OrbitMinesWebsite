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

    SURVIVAL_ICON = new('assets/survival_icon.png')
    KITPVP_ICON = new('assets/kitpvp_icon.png')

    SURVIVAL = new('assets/survival.png')
    KITPVP = new('assets/kitpvp.png')

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

      results.each[0]
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

    end
  end

  class Server
    attr_reader :name, :color, :play_time_column, :icon, :logo

    def initialize(name, color, play_time_column, icon, logo)
      @name = name
      @color = color
      @play_time_column = play_time_column
      @icon = icon
      @logo = logo
    end

    HUB = new('Hub', Color::TEAL, nil, Library::ORBITMINES_ICON, Library::LOGO)
    SURVIVAL = new('Survival', Color::LIME, nil, Library::SURVIVAL_ICON, Library::SURVIVAL)
    KITPVP = new('KitPvP', Color::RED, nil, Library::KITPVP_ICON, Library::KITPVP)

    ALL = [ HUB, SURVIVAL, KITPVP ]
  end

  class Status
    attr_reader :name, :color

    def initialize(name, color)
      @name = name
      @color = color
    end

    ONLINE = new('Online', Color::LIME)
    OFFLINE = new('Offline', Color::RED)
    MAINTENANCE = new('Maintenance', Color::FUCHSIA)
    RESTARTING = new('Restarting', Color::GRAY)
  end

  module Navigation
    class Item
      attr_reader :display, :link

      def initialize(display, link)
        @display = display
        @link = link
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
      Navigation::Item.new('Discord', 'https://discordapp.com/invite/QjVGJMe'),
      Navigation::Item.new('Shop', 'https://orbitmines.buycraft.net'),
      Navigation::Item.new('YouTube', 'https://www.youtube.com/channel/UCjUXtvbrnqx206YnypjagVQ'),
      Navigation::Item.new('Twitter', 'https://www.twitter.com/OrbitMines')
  ]
  IP = 'Hub.OrbitMines.com'
end