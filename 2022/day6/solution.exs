defmodule Solution do
  def parse_input(path, test) do
    case test do
      true -> File.read!(path) |> String.split("\n", trim: true)
      false -> File.read!(path) |> String.trim()
    end
  end

  def find_marker(x, masterlist, startlength) do
    x = to_charlist(x)

    Enum.chunk_every(x, startlength)
    |> Enum.map(fn x -> Enum.uniq(x) end)
    |> List.first()
    |> case do
      y when length(y) < startlength ->
        Enum.slice(x, 1..length(x)) |> find_marker(masterlist, startlength)

      y when length(y) >= startlength ->
        index = Regex.run(~r/#{y}/, masterlist, return: :index) |> List.first()
        elem(index, 0) + elem(index, 1)
    end
  end
end

input = Solution.parse_input("input.txt", false)

test_input = Solution.parse_input("test_input.txt", true)

solution_one = Solution.find_marker(input, input, 4)
solution_two = Solution.find_marker(input, input, 14)
