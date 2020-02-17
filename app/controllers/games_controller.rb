require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json[:found]
  end

  def score
    @grid = params[:letters]
    @guess = params[:word].upcase
    if included?(@guess, @grid) && english_word?(@guess)
      @result = "Congratulations! #{@guess} is a valid English word."
    elsif english_word?(@guess) == false
      @result = "Sorry but #{@guess} does not seem to be a valid English word..."
    else
      @result = "Sorry but #{@guess} can't be built out of #{@grid}"
    end
  end
end
