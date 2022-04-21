

module TeamModule


  def TeamModule.opponent_game_team_info(game_teams, game_info_for_team, team_id)
    opponent_game_info = {}
    game_info_for_team.each do |given_team|
      opponent = game_teams.find{|game_team| ((game_team.team_id != team_id) && (game_team.game_id == given_team.game_id))}
      if opponent
        if opponent_game_info[opponent.team_id]
          opponent_game_info[opponent.team_id] << opponent
        else
          opponent_game_info[opponent.team_id] = [opponent]
        end
      end
    end
    opponent_game_info
  end

  def TeamModule.opponent_win_percentage(opponent_game_info)
    opponent_win_percentage = {}
		opponent_game_info.each do |team_id, game_teams|
			wins_losses = []
			game_teams.each{|game_team| wins_losses << game_team.result}
			win_percentage = (wins_losses.count("WIN").to_f / wins_losses.count) * 100
      opponent_win_percentage[team_id] = win_percentage
		end
    return opponent_win_percentage
  end

  def TeamModule.find_fav_opponent(team_id, teams, game_teams)
    team_id = teams.find{|team| team.team_id == team_id}.team_id
		game_info_for_team = game_teams.find_all{|game_team| game_team.team_id == team_id}
		opponent_game_info = opponent_game_team_info(game_teams, game_info_for_team, team_id)
		opponent_win_percentage = opponent_win_percentage(opponent_game_info)
		fav_opponent_id = opponent_win_percentage.invert.min[1]
		fav_opponent_team = teams.find{|team| team.team_id == fav_opponent_id}
		return fav_opponent_team.team_name
  end

  def TeamModule.find_rival(team_id, teams, game_teams)
    team_id = teams.find{|team| team.team_id == team_id}.team_id
		game_info_for_team = game_teams.find_all{|game_team| game_team.team_id == team_id}
		opponent_game_info = opponent_game_team_info(game_teams, game_info_for_team, team_id)
		opponent_win_percentage = opponent_win_percentage(opponent_game_info)
		rival_id = opponent_win_percentage.invert.max[1]
		rival_team = teams.find{|team| team.team_id == rival_id}
		return rival_team.team_name
  end

  def TeamModule.season_hash(team_id, game_teams)
    game_team_arr = game_teams.find_all do |game|
      game.team_id.to_i == team_id.to_i
    end
    season_record_hash = {}
    game_team_arr.each do |game|
      if season_record_hash[game.game_id[0..3]] == nil
        season_record_hash[game.game_id[0..3]] = [game.result]
      else
        season_record_hash[game.game_id[0..3]] << game.result
      end
    end
    season_record_hash
  end

  def TeamModule.season_win_percentages(team_id, game_teams)
    season_record_hash = TeamModule.season_hash(team_id.to_i, game_teams)
    win_counter = 0
    season_win_percentage_hash = {}
    season_record_hash.each do |season, result|
       win_counter = result.count("WIN")
       win_percentage = (win_counter.to_f / result.count.to_f) * 100
       season_win_percentage_hash[season] = win_percentage
     end
     season_win_percentage_hash
   end

  def TeamModule.win_percentage(game_teams, team_id)
    games_by_team_arr = game_teams.find_all { |game| game.team_id.to_i == team_id.to_i }
    results_arr = games_by_team_arr.map { |games| games.result }
    wins = results_arr.count("WIN")
    win_percentage = (wins.to_f / results_arr.count.to_f).round(2)
    return win_percentage
  end

  def TeamModule.season_worst(game_teams, games, team_id)
    season_win_percentage_hash = TeamModule.season_win_percentages(team_id.to_i, game_teams)
    best_season = season_win_percentage_hash.invert.min
    best_game = games.find do |game|
     best_season[1] == game.season[0..3]
   end
   best_game.season
  end

  def TeamModule.season_best(game_teams, games, team_id)
    season_win_percentage_hash = TeamModule.season_win_percentages(team_id.to_i, game_teams)
    best_season = season_win_percentage_hash.invert.max
    best_game = games.find do |game|
     best_season[1] == game.season[0..3]
   end
   best_game.season
 end

 def TeamModule.team_stats(teams, team_id)
   team_hash = {}
   team = teams.find { |team| team.team_id.to_i == team_id.to_i }
   team_hash['team_id'] = team.team_id
   team_hash['franchise_id'] = team.franchise_id
   team_hash['team_name'] = team.team_name
   team_hash['abbreviation'] = team.abbreviation
   team_hash['link'] = team.link
   team_hash
 end
end
