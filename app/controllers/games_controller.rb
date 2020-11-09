require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    def rnd
      grid = []
      10.times do
        let_arr = ("A".."Z").to_a
        grid << let_arr.sample
      end
      grid
    end
    @letters = rnd
  end

  def valid?(word)
    check = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    checked = JSON.parse(check)
    checked["found"]
  end

  def part?(letter_array, guess)
    letts = guess.upcase.split(//)
    letts.all? { |x| letts.count(x) <= letter_array.count(x) }
  end

  def score
    @letters = params[:letters].split
    guess = params[:guess]
    start_time = params[:start]
    end_time = params[:end]

    if valid?(guess) && part?(@letters, guess)
      @score = guess.length
      @message = "Well done, your score is #{@score}!"
    elsif !valid?(guess) && part?(@letters, guess)
      @message = "This is not a valid word."
    elsif valid?(guess) && !part?(@letters, guess)
      @message = "This word is not part of the grid"
    else
      @message = "This is neither an english word, nor part of the grid. Super fail!"
    end
  end
end
