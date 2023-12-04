defmodule Solution do
  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": ", trim: true))
    |> Enum.map(&tl(&1))
    |> List.flatten()
  end

  def score(input) do
    [numbers, winning] = String.split(input, "| ", trim: true)
    numbers = Regex.split(~r'\s+', numbers, trim: true)
    winning = Regex.split(~r'\s+', winning, trim: true)
    common_elements = Enum.filter(numbers, &(&1 in winning))

    Enum.reduce(common_elements, 0, fn _x, acc -> if acc == 0, do: 1, else: acc * 2 end)
  end

  def parse_input_two(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": ", trim: true))
  end
end

one = Solution.parse_input("./input.txt") |> Enum.map(&Solution.score/1) |> Enum.sum()
