defmodule Solution do
  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      Regex.split(~r"\d+", x, include_captures: true)
      |> Enum.filter(fn x -> if Integer.parse(x) !== :error, do: true, else: false end)
      |> Enum.map(fn x -> String.to_integer(x) end)
    end)
  end

  def zip([time, distance]) do
    Enum.zip(time, distance)
  end

  def find_winning({time, distance}) do
    holds = Enum.to_list(0..time)

    numbers =
      Enum.map(holds, fn hold ->
        difference = distance - hold
        remaining_time = time - hold
        total = remaining_time * hold
      end)
      |> Enum.filter(fn traveled -> traveled > distance end)
      |> Enum.count()
  end
end

one =
  Solution.parse_input("./input.txt")
  |> Solution.zip()
  |> Enum.map(&Solution.find_winning/1)
  |> Enum.reduce(fn x, acc -> x * acc end)

two =
  Solution.parse_input("./input.txt")
  |> Enum.map(fn x -> Enum.join(x) end)
  |> Enum.map(fn x -> [String.to_integer(x)] end)
  |> Solution.zip()
  |> Enum.map(&Solution.find_winning/1)
  |> List.first()
