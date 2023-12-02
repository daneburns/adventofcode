defmodule Game do
  defstruct [:id, :red, :green, :blue]
end

defmodule Solution do
  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Solution.transform()
  end

  def transform(input) do
    Enum.map(input, fn x ->
      [game | rest] = String.split(x, ": ")
      number = String.split(game, " ") |> List.last() |> String.to_integer()
      games = String.split(rest |> List.first(), "; ")
      maxes = Solution.get_maxes(games, number)
    end)
  end

  def get_maxes(games, number) do
    parsed = Enum.flat_map(games, &Solution.parse_games(&1))

    Enum.reduce(parsed, %{red: 0, green: 0, blue: 0}, fn {color, number}, acc ->
      as_atom = String.to_existing_atom(color)
      current_value = Map.fetch!(acc, as_atom)
      if current_value < number, do: Map.put(acc, as_atom, number), else: acc
    end)
    |> Map.put(:id, number)
  end

  def parse_games(game) do
    regex = ~r/(\d+)\s*(\w+)/

    Regex.scan(regex, game)
    |> Enum.map(fn [_match, num, color] -> {color, String.to_integer(num)} end)
  end

  def compare(maxes, test) do
    possible =
      Enum.filter(maxes, fn x ->
        red_max = Map.fetch!(test, :red)
        green_max = Map.fetch!(test, :green)
        blue_max = Map.fetch!(test, :blue)

        case x do
          x when x.green > green_max -> false
          x when x.red > red_max -> false
          x when x.blue > blue_max -> false
          _ -> true
        end
      end)
  end

  def get_power(%{id: _id, green: green, red: red, blue: blue}) do
    green * red * blue
  end
end

one =
  Solution.parse_input("./input.txt")
  |> Solution.compare(%{red: 12, green: 13, blue: 14})
  |> Enum.reduce(0, fn x, acc -> Map.fetch!(x, :id) + acc end)

two =
  Solution.parse_input("./input.txt")
  |> Enum.map(fn x -> Solution.get_power(x) end)
  |> Enum.sum()
