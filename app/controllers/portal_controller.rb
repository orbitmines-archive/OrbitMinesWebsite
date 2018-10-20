class PortalController < ApplicationController

  def index
    @player_count = 0
    @servers = {}

    OrbitMines::DATABASE.get(OrbitMines::Database::Table::SERVERS, [ OrbitMines::Database::Table::Servers::SERVER, OrbitMines::Database::Table::Servers::STATUS, OrbitMines::Database::Table::Servers::PLAYERS, OrbitMines::Database::Table::Servers::MAX_PLAYERS ]).each do |entry|
      server = OrbitMines::Server::from(entry[OrbitMines::Database::Table::Servers::SERVER.name])
      status = OrbitMines::Status::from(entry[OrbitMines::Database::Table::Servers::STATUS.name])
      players = entry[OrbitMines::Database::Table::Servers::PLAYERS.name].to_i
      max_players = entry[OrbitMines::Database::Table::Servers::MAX_PLAYERS.name].to_i

      puts "#{server}, #{status}, #{players}/#{max_players}"

      @player_count += players if (status == OrbitMines::Status::ONLINE)

      play_time_seconds = OrbitMines::DATABASE.sum(OrbitMines::Database::Table::PLAY_TIME, server.play_time_column)
      play_time_hours = play_time_seconds / 3600

      @servers[server] = ServerStatus.new(server, status, players, max_players, play_time_hours)
    end
  end


end

class ServerStatus
  attr_reader :server, :status, :players, :max_players, :play_time

  def initialize(server, status, players, max_players, play_time)
    @server = server
    @status = status
    @players = players
    @max_players = max_players
    @play_time = play_time
  end
end