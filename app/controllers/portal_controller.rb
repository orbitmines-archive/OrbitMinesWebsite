class PortalController < ApplicationController

  def index
    @player_count = { 'TOTAL' => 0 }

    OrbitMines::DATABASE.get(OrbitMines::Database::Table::SERVERS, [ OrbitMines::Database::Table::Servers::SERVER, OrbitMines::Database::Table::Servers::PLAYERS ], OrbitMines::Database::Table::Servers::STATUS => OrbitMines::Status::ONLINE.name).each do |server, player_count|
      int_player_count = player_count.to_i
      @player_count[server] = int_player_count
      @player_count['TOTAL'] = @player_count['TOTAL'] + int_player_count
    end
  end
end