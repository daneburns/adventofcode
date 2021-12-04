defmodule Submarine do
  def master_bit(num, list_length) do
    half = list_length / 2

    case num do
      num when num >= half -> 1
      _ -> 0
    end
  end

  def gamma_rate(nested_list) do
    integer_list =
      nested_list
      |> Enum.map(&String.to_integer(List.first(&1)))

    [
      Enum.sum(Enum.take_every(integer_list, 12)),
      Enum.sum(Enum.take_every(Enum.slice(integer_list, 1..-1), 12)),
      Enum.sum(Enum.take_every(Enum.slice(integer_list, 2..-1), 12)),
      Enum.sum(Enum.take_every(Enum.slice(integer_list, 3..-1), 12)),
      Enum.sum(Enum.take_every(Enum.slice(integer_list, 4..-1), 12)),
      Enum.sum(Enum.take_every(Enum.slice(integer_list, 5..-1), 12)),
      Enum.sum(Enum.take_every(Enum.slice(integer_list, 6..-1), 12)),
      Enum.sum(Enum.take_every(Enum.slice(integer_list, 7..-1), 12)),
      Enum.sum(Enum.take_every(Enum.slice(integer_list, 8..-1), 12)),
      Enum.sum(Enum.take_every(Enum.slice(integer_list, 9..-1), 12)),
      Enum.sum(Enum.take_every(Enum.slice(integer_list, 10..-1), 12)),
      Enum.sum(Enum.take_every(Enum.slice(integer_list, 11..-1), 12)),
      Enum.sum(Enum.take_every(Enum.slice(integer_list, 12..-1), 12))

    ]
  end

  def epsilon_rate(gamma_rate_binary) do
    Enum.map(gamma_rate_binary, fn x ->
      case x do
        1 -> 0
        _ -> 1
      end
    end)
  end
end

gamma_rate =
  File.cwd!()
  |> Path.join("input.txt")
  |> File.read!()
  |> String.split("\r\n", trim: true)
  |> Enum.map(&String.codepoints(&1))
  |> Enum.flat_map(&Enum.chunk_every(&1, 1))
  |> Submarine.gamma_rate()
  |> Enum.map(&Submarine.master_bit(&1, 1000))
  |> Enum.join()
  |> Integer.parse(2)
  |> elem(0)

epsilon_rate =
  File.cwd!()
  |> Path.join("test_input.txt")
  |> File.read!()
  |> String.split("\r\n", trim: true)
  |> Enum.map(&String.codepoints(&1))
  |> Enum.flat_map(&Enum.chunk_every(&1, 1))
  |> Submarine.gamma_rate()
  |> Enum.map(&Submarine.master_bit(&1, 1000))
  |> Submarine.epsilon_rate()
  |> Enum.join()
  |> Integer.parse(2)
  |> elem(0)

IO.puts(epsilon_rate * gamma_rate)

# Post - mortem #
# I wanted to essentially make the list completely flat, then construct a new list using that list (every nth element), sum those and determine
# if they were greater than half the length of the list (given modulo 2 = 0) else greater than or equal to. That would determine the final bit, which could be used for power consumption calc.
