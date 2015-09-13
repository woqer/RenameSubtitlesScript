#!/usr/bin/env ruby
#encoding: utf-8

require "pp"

class RecursivePattern
  attr_reader :guess, :iteration
  def initialize(args={})
    @guess = args[:guess] || ""
    @iteration = args[:iteration] || 0
  end
end

module VideoFile
  def episode_patterns_lvl1
    [/S\d+E\d+/, /\d+x\d+/, /.*\d+/]
  end

  def episode_patterns_lvl2
    [/E\d+/, /x\d+/, /\d+/]
  end

  def video_extension_patterns
    ["mkv", "avi", "mp4"]
  end

  def subtitle_extension_patterns
    ["srt", "sub"]
  end

  def try_match(name, pattern_array, iteration)
    return RecursivePattern.new(iteration: iteration) if iteration > 2
      
    guess = name[pattern_array[iteration]]

    if guess.nil?
      try_match name, pattern_array, iteration + 1
    else
      return RecursivePattern.new(guess: guess, iteration: iteration)
    end
  end

  def get_episode_number(file_name)
    guess_response = try_match(file_name, episode_patterns_lvl1, 0)
    guess2 = guess_response.guess[episode_patterns_lvl2[guess_response.iteration]]
    guess2[/\d+/]
  end

  def identify_file(name)
    video_name_response = try_match name, video_extension_patterns, 0

    if video_name_response.guess.eql? ""
      subtitle_name_response = try_match name, subtitle_extension_patterns, 0
      return :subtitle, name
    else
      return :video, name
    end
  end
end

class VideoElement
  include VideoFile
  attr_reader :episode, :name

  def initialize(name)
    @episode = episode_initializer name
    @name = name
  end

  def episode_initializer(name)
    get_episode_number name    
  end
end

VideoFileClass = Class.new{extend VideoFile}

def process(line)
  VideoFileClass.identify_file line
end


input = {subtitle: [], video: []}

$stdin.each_line do |line|
  key, value = process line
  input[key] << VideoElement.new(value.gsub("\n",""))
end

pp input
