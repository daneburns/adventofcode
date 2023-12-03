defmodule Solution do
  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
  end

  def is_symbol?(char), do: if(char !== ".", do: true, else: false)

  def parse(input) do
    indexed = Enum.with_index(input)
    valid_part_number(indexed)
  end

  def valid_part_number(indexed) do
    Enum.flat_map(indexed, fn x -> positions(x, indexed) end)
    |> Enum.map(fn x -> if is_valid?(x), do: String.to_integer(x.part_number), else: [] end)
    |> List.flatten()

    # |> Enum.filter(fn x -> !is_nil(x) end)
    # |> Enum.map(fn x -> String.to_integer(x) end)
    # |> IO.inspect()
  end

  def is_valid?(position) do
    left = is_symbol?(position.left)
    right = is_symbol?(position.right)

    top =
      if !is_nil(position.top),
        do:
          String.split(position.top, "", trim: true)
          |> IO.inspect()
          |> Enum.map(fn x -> is_symbol?(x) end)
          |> IO.inspect()

    bottom =
      if !is_nil(position.bottom),
        do: String.split(position.bottom, "", trim: true) |> Enum.any?(fn x -> is_symbol?(x) end)

    IO.inspect(position)
    IO.inspect([top, left, right, bottom])
    Enum.any?([top, left, right, bottom])
  end

  def positions(x, indexed) do
    {value, index} = x
    above = if index - 1 >= 0, do: Enum.at(indexed, index - 1) |> elem(0), else: nil
    below = if index < length(indexed) - 1, do: Enum.at(indexed, index + 1) |> elem(0), else: nil

    pattern = ~r'\d+'

    Regex.scan(pattern, value, return: :index)
    |> Enum.map(&get_positions(&1, above, below, value))
  end

  def get_positions(match, above, below, string) do
    [{index, length}] = match

    part_number = String.slice(string, index, length)

    left = if index > 0, do: String.slice(string, index - 1, 1), else: nil

    right =
      if index + length < String.length(string),
        do: String.slice(string, index + length, 1),
        else: nil

    top_offset = if is_nil(left) or is_nil(right), do: 1, else: 0

    top =
      if !is_nil(above),
        do: String.slice(above, index - top_offset, length + 2 - top_offset),
        else: nil

    bottom = if !is_nil(below), do: String.slice(below, index - 1, length + 2), else: nil

    %{part_number: part_number, left: left, right: right, top: top, bottom: bottom}
  end
end

Solution.parse_input("./input.txt") |> Solution.parse() |> Enum.sum() |> IO.inspect()
