require_relative '../required_files'

class StatTracker
	include TeamModule
	include GameModule
	include LeagueModule
	include SeasonModule

	attr_reader :games, :teams, :game_teams

	def initialize(games_hash, teams_hash, game_teams_hash)
		@games = Game.create_games(games_hash)
		@teams = Team.create_teams(teams_hash)
		@game_teams = GameTeam.create_game_teams(game_teams_hash)
	end

	def self.from_csv(locations)
	 games_hash = CSV.open(locations[:games], headers: true, header_converters: :symbol)
	 teams_hash = CSV.open(locations[:teams], headers: true, header_converters: :symbol)
	 game_teams_hash = CSV.open(locations[:game_teams], headers: true, header_converters: :symbol)
	 stat_tracker1 = self.new(games_hash, teams_hash, game_teams_hash)
	end

	def game_count
		@games.count
	end

	def highest_total_score
		GameModule.total_score(@games).max
	end

	def lowest_total_score
		GameModule.total_score(@games).min
	end

	def percentage_visitor_wins
		return ((GameModule.total_visitor_wins(@games).count).to_f / (@games.count).to_f).round(2)
	end

	def percentage_home_wins
		return ((GameModule.total_home_wins(@games).count).to_f / game_count.to_f).round(2)
	end

	def average_goals_per_game
		(GameModule.total_score(@games).sum.to_f / game_count).round(2)
	end

	def average_goals_by_season
		GameModule.goals_by_season(@games)
	end

	def count_of_teams
		LeagueModule.total_team_count(@teams).count
	end

	def team_info(team_id)
		TeamModule.team_stats(@teams, team_id)
	end

	def best_season(team_id)
		TeamModule.season_best(@game_teams, @games, team_id)
	end

	def worst_season(team_id)
		TeamModule.season_worst(@game_teams, @games, team_id)
	end

	def most_tackles(season_id)
		tackles_hash = SeasonModule.tackles_hash(season_id, @game_teams)
		tackle_id = tackles_hash.sort_by{|team_id, tackles| tackles}.last[0]
		LeagueModule.team_name_by_id(tackle_id, @teams)
	end

	def fewest_tackles(season_id)
		tackles_hash = SeasonModule.tackles_hash(season_id, @game_teams)
		tackle_id = tackles_hash.sort_by{|team_id, tackles| tackles}.first[0]
		LeagueModule.team_name_by_id(tackle_id, @teams)
	end

	def average_win_percentage(team_id)
		TeamModule.win_percentage(@game_teams, team_id)
	end

	def best_offense
		LeagueModule.find_best_offense(@game_teams, @teams)
	end

	def worst_offense
		LeagueModule.find_worst_offense(@game_teams, @teams)
	end

	def most_goals_scored(team_id)
		LeagueModule.goals_scored(team_id, @game_teams).max
	end

	def fewest_goals_scored(team_id)
		LeagueModule.goals_scored(team_id, @game_teams).min
  end

	def winningest_coach(season)
		SeasonModule.best_coach(season, @game_teams)
  end

	def worst_coach(season)
		SeasonModule.worst_coach(season, @game_teams)
	end

	def most_accurate_team(season)
		SeasonModule.best_team(season, @game_teams, @teams)
	end

	def least_accurate_team(season)
		SeasonModule.worst_team(season, @game_teams, @teams)
  end

	def percentage_ties
		ties = @games.select { |game| game.home_goals == game.away_goals }
		return ((ties.count.to_f / game_count.to_f)).round(2)
	end

	def count_of_games_by_season
		GameModule.season_count_of_games(@games)
	end

  def favorite_opponent(team_id)
		TeamModule.find_fav_opponent(team_id, @teams, @game_teams)
  end

	def rival(team_id)
		TeamModule.find_rival(team_id, @teams, @game_teams)
	end

	def highest_scoring_visitor
		LeagueModule.highest_visitor_score(@games, @teams)
	end

	def lowest_scoring_visitor
		LeagueModule.lowest_visitor_score(@games, @teams)
	end

	def highest_scoring_home_team
		LeagueModule.highest_home_team_score(@games, @teams)
	end

	def lowest_scoring_home_team
		LeagueModule.lowest_home_team_score(@games, @teams)
	end
end
