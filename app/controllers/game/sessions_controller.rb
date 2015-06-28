class Game::SessionsController < ApplicationController
  protect_from_forgery except: :create

  def index
    @sessions = Session.all
  end

  def new
    @games = Game.all
    @players = Player.all
  end

  def create
    players = params[:session_players]
    identified_players = players.select { |p| p[:player_id].to_i > 0 }

    # Only allow duplicate unknown players
    if identified_players.map { |p| p[:player_id] }.uniq.length != identified_players.length
      raise ActionController::BadRequest.new('Duplicate Players')
    end

    @session = Session.new
    @session.game_id = params[:game_id]
    @session.save

    players.each do |player|
      @session_player = SessionPlayer.new
      @session_player.session_id = @session.id
      @session_player.player_id = player[:player_id]
      @session_player.placing = player[:placing]
      @session_player.score = player[:score]
      @session_player.team_number = player[:team]
      @session_player.save
    end

    render :json => { 'url' => root_url }
  end

  def show
    @session = Session.find(params[:id])
  end

  private
  def session_params
    params.require(:session).permit(:players, :game_id)
  end
end