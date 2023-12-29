# frozen_string_literal: true

require 'json'

class IndexController < ApplicationController
  before_action :parse_params, only: :output

  def input; end

  def output
    find_res = Index.find_by(array: @array)
    if find_res.nil?
      @result = Solve.call @array
      if @result.nil?
        @error = 'Некорректный ввод'
      elsif @result.length.positive?
        @longest_one = @result[@result.map { |a| a[0].length }.each_with_index.max[1]]
      end
      add if @error.nil?
    else
      parse_find_res(find_res)
    end
  end

  private

  def parse_params
    # Normalize array before action
    @array = params[:a]&.strip&.split&.join(' ')
  end

  def add
    Index.create_from_arr(@array, @result, !@error.nil?, @longest_one)
  end

  def parse_find_res(find_res)
    @error = find_res.result ? 'Некорректный ввод' : nil
    unless @error.nil?
      @result = JSON.parse(find_res.result)
      @longest_one = JSON.parse(find_res.longest_one) unless find_res.longest_one.nil?
    end
  end
end
