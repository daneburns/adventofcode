defmodule Solution do
  def parse_input(path) do
    string =
      File.read!(path)
      |> String.split("\n", trim: true)

    [seeds | tail] = string
    seeds = seeds |> String.split(": ") |> List.last() |> String.split(" ", trim: true)
    tail = Enum.chunk_by(tail, fn x -> Regex.match?(~r/\d/, x) end) |> Enum.chunk_every(2)

    %{seeds: seeds |> Enum.map(&String.to_integer/1), map: Enum.map(tail, &map_ranges/1)}
  end

  def define_ranges(nums) do
    Enum.map(nums, fn y ->
      String.split(y, " ", trim: true)
    end)
    |> Enum.map(fn [x, y, z] ->
      %{
        destination: String.to_integer(x),
        source: String.to_integer(y),
        length: String.to_integer(z)
      }
    end)
  end

  def map_ranges(input) do
    [map_name | ranges] = input

    map_name ++ Enum.map(ranges, &define_ranges/1)
  end

  def find_corresponding(number, [], acc) do
    acc
  end

  def find_corresponding(seed_number, map, corr \\ %{}) do
    corr = if !Map.has_key?(corr, "seed"), do: Map.put(corr, "seed", seed_number), else: corr
    [head | tail] = map
    [name | ranges] = head
    name = name |> String.split("-") |> Enum.at(2) |> String.split(" ") |> Enum.at(0)

    correct_map =
      Enum.filter(ranges |> List.flatten(), fn range ->
        new_range = Range.new(range.source, range.source + range.length)
        seed_number in new_range
      end)

    if length(correct_map) > 0 do
      correct_map = correct_map |> List.first()

      val = correct_map.destination - correct_map.source

      new_number = seed_number + val
      find_corresponding(new_number, tail, Map.put(corr, name, new_number))
    else
      find_corresponding(seed_number, tail, Map.put(corr, name, seed_number))
    end
  end

  def find_numbers(input) do
    Enum.map(input.seeds, fn x -> find_corresponding(x, input.map) end)
  end

  def get_lowest_location(input) do
    Enum.map(input, fn x -> x["location"] end) |> Enum.min()
  end
end

one =
  Solution.parse_input("./input.txt")
  |> Solution.find_numbers()
  |> Solution.get_lowest_location()
  |> IO.inspect()
