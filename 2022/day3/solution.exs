defmodule Solution do
  def parse_input(path) do
    File.read!(path)
    |> String.split("\n")
  end

  def make_compartment(bag) do
    String.split_at(bag, trunc(String.length(bag) / 2))
  end

  def find_common({compartment1, compartment2}) do
    Enum.filter(to_charlist(compartment2), fn x ->
      Enum.member?(to_charlist(compartment1), x)
    end)
  end

  def find_common([one, two, three]) do
    first_two = find_common({one, two})

    find_common({first_two, three}) |> Enum.at(0)
  end

  def map_priority(char) do
    alphabit = Enum.to_list(?a..?z) ++ Enum.to_list(?A..?Z)

    Enum.find_index(alphabit, fn x -> char == x end)
    |> Kernel.+(1)
  end
end

test_input = Solution.parse_input("test_input.txt")
second_test_input = Solution.parse_input("test_input2.txt")

input = Solution.parse_input('input.txt')

solution_one =
  input
  |> Enum.map(&Solution.make_compartment(&1))
  |> Enum.map(&Solution.find_common(&1))
  |> Enum.map(fn x -> Enum.at(x, 0) end)
  |> List.flatten()
  |> Enum.reject(fn x -> is_nil(x) end)
  |> Enum.map(&Solution.map_priority/1)
  |> Enum.sum()

solution_two =
  input
  |> Enum.chunk_every(3)
  |> Enum.reject(fn x -> length(x) < 3 end)
  |> Enum.map(fn x -> Solution.find_common(x) end)
  |> Enum.map(fn x -> Solution.map_priority(x) end)
  |> Enum.sum()
