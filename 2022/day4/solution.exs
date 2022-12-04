defmodule Solution do
  def make_ranges(<<first_digit::binary-size(1)>> <> "-" <> <<second_digit::binary-size(1)>>) do
    Enum.to_list(String.to_integer(first_digit)..String.to_integer(second_digit))
  end

  def make_ranges(<<first_digit::binary-size(1)>> <> "-" <> <<second_digit::binary-size(2)>>) do
    Enum.to_list(String.to_integer(first_digit)..String.to_integer(second_digit))
  end

  def make_ranges(<<first_digit::binary-size(2)>> <> "-" <> <<second_digit::binary-size(1)>>) do
    Enum.to_list(String.to_integer(first_digit)..String.to_integer(second_digit))
  end

  def make_ranges(<<first_digit::binary-size(2)>> <> "-" <> <<second_digit::binary-size(2)>>) do
    Enum.to_list(String.to_integer(first_digit)..String.to_integer(second_digit))
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn x -> Enum.map(x, fn y -> make_ranges(y) end) end)
  end

  def find_inclusive([first, second]) do
    diff = List.myers_difference(first, second)

    case diff[:eq] do
      x when x == first -> :inclusive
      x when x == second -> :inclusive
      _ -> []
    end
  end

  def find_overlap([first, second]) do
    (first ++ second)
    |> Enum.frequencies()
    |> Enum.filter(fn x -> elem(x, 1) > 1 end)
  end
end

input = Solution.parse_input('input.txt')
test_input = Solution.parse_input('test_input.txt')

solution_one =
  input
  |> Enum.map(fn x -> Solution.find_inclusive(x) end)
  |> List.flatten()
  |> Enum.count()

solution_two =
  input
  |> Enum.map(fn x -> Solution.find_overlap(x) end)
  |> Enum.reject(fn x -> x == [] end)
  |> Enum.count()
