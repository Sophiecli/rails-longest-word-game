require 'open-uri'
require 'json'


class GamesController < ApplicationController

  def new
    @letters = ('a'..'z').to_a.sample(10)
    @start_time = Time.now
  end

  def score
    attempt = params["result"].downcase
    letters = params[:letters].split
    start_time = DateTime.parse(params[:start_time]) #string
    end_time = Time.now

    time = end_time - start_time


    if included?(attempt, letters)
      if english_word?(attempt)
        if time > 60.0
          @result = 0
        else
          @result  = attempt.size * (1.0 - time / 60.0)
        end
      else
        @result = "not an english word"
      end
    else
      @result = "Not in the grid"
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    puts json
    return json['found']
  end

  def run_game(attempt, letters)
    if included?(attempt, letters)
      if english_word?(attempt)
        score = 15
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end

end
