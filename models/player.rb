require_relative 'player'
require_relative 'frame'
require_relative 'final_frame'
require_relative 'score_calculator'

class Player
  attr_reader :name, :frames, :frame_count, :score_calculator

  def initialize(name, frame_count, score_calculator = ScoreCalculator.new)
    @name = name
    @frames = []
    @frame_count = frame_count
    @current_frame = 0
    @score_calculator = score_calculator
  end

  def roll(pins)
    raise RollLimitException if @current_frame == frame_count

    setup_frame if frames[@current_frame].nil?
    frames[@current_frame].add_roll(pins)
    @current_frame += 1 if frames[@current_frame].complete?
  end

  def score
    score_calculator.calculate_score(frames)
  end

  private

  def setup_frame
    frames << if @current_frame < frame_count - 1
                Frame.new
              else
                FinalFrame.new
              end
  end
end
