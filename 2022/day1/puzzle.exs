defmodule Calories do
  def find_top(totals, accum, count) do
    if length(accum) < count do
      highest = Enum.max(totals)
      highest_index = Enum.find_index(totals, fn x -> x == highest end)
      new_list = List.delete_at(totals, highest_index)
      find_top(new_list, accum ++ [highest], count)
    else
      accum
    end
  end

  def get_totals() do
    input = File.read("input.txt") |> elem(1)

    parsed =
      String.split(input, "\n")
      |> Enum.chunk_by(fn x -> x == "" end)
      |> Enum.filter(fn x -> x !== [""] end)
      |> Enum.map(fn x -> Enum.map(x, fn y -> String.to_integer(y) end) end)

    totals = Enum.map(parsed, fn x -> Enum.sum(x) end)
  end
end

totals = Calories.get_totals()

highest_calories = totals |> Enum.max()

top_three = Calories.find_top(totals, [], 3)

top_three_total = Enum.sum(top_three)
