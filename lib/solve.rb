# frozen_string_literal: true

class Solve
  class << self
    def call(arr)
      new(arr).send :execute
    end
  end

  private

  def initialize(arr)
    @array = arr&.split&.map { |x| Integer(x) }
    @error_input = arr.length.zero?
  rescue ArgumentError
    @error_input = true
  end

  def perfect(num)
    num == (1...num).select { |i| (num % i).zero? }.inject(:+)
  end

  def execute
    # here comes the solution!
    return unless !@error_input && !@array.nil?

    ans = []
    n = @array.length
    n.times do |p1|
      (p1..n - 1).each do |p2|
        break unless perfect(@array[p2])

        ans << [@array[p1..p2], (p1 == p2 ? [p1] : [p1, p2])]
      end
    end
    ans
  end
end
