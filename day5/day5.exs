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

  def expand_range(four_tuple) do
    {x1, y1, x2, y2} = four_tuple
    four_tuple

    # [Enum.map(x1..x2, fn x -> x end), Enum.map(y1..y2, fn x -> x end)]
    # |> Enum.filter(&is_list/1)
    # |> List.flatten()
  end

  def count_intersects(input) do
    input
    |> List.flatten()
    |> Enum.frequencies()
    |> IO.inspect()
    |> Enum.filter(fn {x, y} -> y >= 2 end)
    |> IO.inspect()
  end

  def assemble_lines(input) do
    # take flat data [1, 2, 3, 4] and return list of x,y tuples [{x1, y1, x2, y2}, ... n]
    input
    |> Enum.chunk_every(4)
    |> Enum.map(&List.to_tuple(&1))
  end
end

File.cwd!()
|> Path.join("test_input.txt")
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
|> IO.inspect()

# |> Vents.count_intersects()
# |> Enum.count()
# |> IO.puts()
