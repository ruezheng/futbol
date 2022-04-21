module GameModule

  def GameModule.total_score(games)
    score_arr = []
    games.each do |game|
      score_arr << game.away_goals.to_i + game.home_goals.to_i
    end
    return score_arr
  end

  def GameModule.total_home_wins(games)
		total_home_wins = []
		games.each do |game|
			if game.home_goals.to_f > game.away_goals.to_f
				total_home_wins << game
			end
		end
		return total_home_wins
  end

  def GameModule.total_visitor_wins(games)
    total_visitor_wins = []
    games.each do |game|
      if game.home_goals.to_f < game.away_goals.to_f
        total_visitor_wins << game
      end
    end
    return total_visitor_wins
  end

  def GameModule.season_goals(games)
    season_goals = {}
    games.each do |game|
      season = game.season
      if season_goals[season] == nil
        season_goals[season] = [game.away_goals.to_i + game.home_goals.to_i]
      else
        season_goals[season] << game.away_goals.to_i + game.home_goals.to_i
      end
    end
    return season_goals
  end

  def GameModule.goals_by_season(games)
    season_goals_avg = GameModule.season_goals(games)
    season_goals_avg.each do |season, goals|
      season_goals_avg[season] = (goals.sum.to_f / goals.count.to_f).round(2)
    end
    return season_goals_avg
  end

  def GameModule.season_count_of_games(games)
    seasons_arr = games.map { |game| game.season }
    game_count_by_season = Hash.new
    seasons_arr.uniq.each do |season|
      game_count_by_season[season] = seasons_arr.count(season)
    end
    return game_count_by_season
  end
end
