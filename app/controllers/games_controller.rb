require 'json'
require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(Q F M R K L I T P)
  def new
    @letters = Array.new(10) { VOWELS.sample }
    @letters += Array.new(10) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    @grid_word = included?(@word, @letters)
    @english_word = english_word?(@word)
    @result = result(@word)
  end

  def included?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end

  def result(word)
    word.size**2
  end
end
