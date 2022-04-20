require './required_files'

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
			game_teams.each do |game_team|
				wins_losses << game_team.result
			end
			win_percentage = (wins_losses.count("WIN"
			).to_f / wins_losses.count.to_f) * 100
			opponent_win_percentage[team_id] = win_percentage
		end
    return opponent_win_percentage
  end

end
