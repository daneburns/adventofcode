defmodule Vents do
  # def create_grid(input) do
  #   # create grid by finding min, max of x and min, max of y
  # end

  def only_orthogonal(input) do
    input
    |> Enum.map(fn line ->
      case line do
        {x, _, x, _} -> line
        {_, y, _, y} -> line
        _ -> nil
      end
    end)
    |> Enum.reject(&is_nil/1)

    # given a list of inputs only return ones that are horizontal and vertical
  end

  def make_pairs([x..y, z]) do
    Enum.into(x..y, [])
    |> Enum.intersperse(z)
    |> Enum.chunk_every(2)
    |> Enum.map(fn
      [single] -> [single, z]
      [single, double] -> [single, double]
    end)
  end

  def make_pairs([z, x..y]) do
    Enum.into(x..y, [])
    |> Enum.intersperse(z)
    |> Enum.chunk_every(2)
    |> Enum.map(fn
      [single] -> [z, single]
      [single, double] -> [double, single]
    end)
  end

  def expand_range(four_tuple) do
    {x1, y1, x2, y2} = four_tuple

    list =
      cond do
        x2 - x1 == 0 -> [x1, y1..y2]
        y2 - y1 == 0 -> [x1..x2, y1]
      end
  end

  def count_intersects(input) do
    input
    |> Enum.frequencies()
    |> Enum.filter(fn {x, y} -> y >= 2 end)
    |> Enum.count()
  end

  def assemble_lines(input) do
    # take flat data [1, 2, 3, 4] and return list of x,y tuples [{x1, y1, x2, y2}, ... n]
    input
    |> Enum.chunk_every(4)
    |> Enum.map(&List.to_tuple(&1))
  end
end

File.cwd!()
|> Path.join("input.txt")
|> File.read!()
|> String.split("\r\n", trim: true)
|> Enum.flat_map(&String.split(&1, " -> ", trim: true))
|> Enum.flat_map(&String.split(&1, ",", trim: true))
|> Enum.flat_map(
  &case Integer.parse(&1) do
    {int, _rest} -> [int]
    :error -> nil
  end
)
|> Vents.assemble_lines()
|> Vents.only_orthogonal()
|> Enum.map(&Vents.expand_range(&1))
|> Enum.flat_map(&Vents.make_pairs(&1))
|> Vents.count_intersects()
|> IO.puts()
