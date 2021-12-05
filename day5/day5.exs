defmodule Vents do
  def create_grid(input) do
    # create grid by finding min, max of x and min, max of y
  end

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

  def assemble_lines(input) do
    # take flat data [1, 2, 3, 4] and return list of x,y tuples [{x1, y1, x2, y2}, ... n]
    input
    # |> Enum.reduce(fn x, acc -> x * acc end)
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
    # transform to integer
    {int, _rest} -> [int]
    # skip the value
    :error -> []
  end
)
|> Vents.assemble_lines()
|> Vents.only_orthogonal()
|> IO.inspect()
