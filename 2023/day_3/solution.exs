defmodule Solution do
  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
  end

  defp is_symbol?(char) when char in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], do: false
  defp is_symbol?(nil), do: false
  defp is_symbol?("."), do: false
  defp is_symbol?(<<_char>>), do: true

  def find_valid(input) do
    line_length = Enum.at(input, 0) |> String.length()
    joined = Enum.join(input)

    pattern = ~r'\d{1,3}'

    Regex.scan(pattern, joined, return: :index)
    |> Enum.map(fn x ->
      find_positions(x, line_length, joined |> String.split("", trim: true))
    end)
    |> Enum.map(fn x -> if is_valid?(x), do: String.to_integer(x.part_number), else: nil end)
    |> Enum.filter(fn x -> !is_nil(x) end)
  end

  def find_positions(match, line_length, joined) do
    [{index, length}] = match
    part_number = Enum.slice(joined, index, length)

    top = fetch_top(part_number, index, length, joined, line_length)
    bottom = fetch_bottom(part_number, index, length, joined, line_length)
    left = if rem(index, line_length) !== 0, do: safe_fetch(joined, index - 1), else: nil

    right =
      if rem(index + length, line_length) !== 0, do: safe_fetch(joined, index + length), else: nil

    corners = fetch_corners({index, length}, joined, line_length)

    %{
      part_number: part_number |> Enum.join(),
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      corners: corners
    }
  end

  def is_valid?(x) do
    symbols =
      Map.values(x)
      |> List.flatten()
      |> Enum.filter(fn x -> !is_nil(x) end)
      |> Enum.filter(fn x ->
        parsed = Integer.parse(x)
        if parsed == :error, do: true, else: false
      end)
      |> Enum.any?(fn x -> is_symbol?(x) end)
  end

  def fetch_corners({index, lngth}, joined, line_length) do
    top_left =
      if rem(index, line_length) !== 0, do: safe_fetch(joined, index - line_length - 1), else: nil

    top_right =
      if rem(index + lngth, line_length) !== 0,
        do: safe_fetch(joined, index + lngth - line_length),
        else: nil

    bottom_left =
      if rem(index, line_length) !== 0, do: safe_fetch(joined, index + line_length - 1), else: nil

    bottom_right =
      if rem(index + lngth, line_length) !== 0,
        do: safe_fetch(joined, index + lngth + line_length),
        else: nil

    [top_left, top_right, bottom_left, bottom_right]
  end

  def fetch_top(part_number, index, length, joined, line_length) do
    part_number = Enum.with_index(part_number)

    Enum.map(part_number, fn {x, y} ->
      safe_fetch(joined, index + y - line_length)
    end)
  end

  def fetch_bottom(part_number, index, length, joined, line_length) do
    part_number = Enum.with_index(part_number)

    Enum.map(part_number, fn {x, y} ->
      safe_fetch(joined, index + y + line_length)
    end)
  end

  def safe_fetch(list, index) when is_integer(index) do
    if index >= 0 and index < length(list) do
      Enum.at(list, index)
    else
      nil
    end
  end
end

one =
  Solution.parse_input("./input.txt")
  |> Solution.find_valid()
  |> Enum.sum()
