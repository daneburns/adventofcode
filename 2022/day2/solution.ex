defmodule Game do
  def parse_input(input) do
    File.read!(input)
  end
end

score = Game.parse_input("input.txt") |> IO.inspect()
