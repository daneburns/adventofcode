defmodule Solution do
  def parse_input(path) do
    parsed =
      File.read!(path)
      |> String.split("\n\n")

    stacks =
      List.first(parsed)
      |> String.split("\n")

    # |> Enum.map(fn x -> create_row(x) end)
    row_count =
      List.last(stacks)
      |> String.split("  ")
      |> Enum.map(fn x -> String.trim(x) end)
      |> List.last()
      |> String.to_integer()

    rows =
      stacks
      |> Enum.drop(-1)
      |> Enum.map(fn x -> String.split(x, "", trim: true) end)
      |> Enum.map(fn x -> Enum.chunk_every(x, 4) end)
      |> IO.inspect()
      |> Enum.map(fn x -> Enum.map(x, fn y -> parse_row(y) end) end)
      |> transpose()

    moves =
      Enum.at(parsed, 1)
      |> String.split("\n")
      |> Enum.drop(-1)
      |> Enum.map(fn x -> String.split(x, " ") end)
      |> Enum.map(fn x -> Enum.reject(x, fn y -> Integer.parse(y) == :error end) end)
      |> Enum.map(fn x ->
        %{
          move: String.to_integer(Enum.at(x, 0)),
          from: String.to_integer(Enum.at(x, 1)),
          to: String.to_integer(Enum.at(x, 2))
        }
      end)

    {rows, moves}
  end

  def parse_row([" ", " ", " ", " "]) do
    nil
  end

  def parse_row([" ", " ", " "]) do
    nil
  end

  def parse_row(["[", letter, "]", " "]) do
    letter
  end

  def parse_row(["[", letter, "]"]) do
    letter
  end

  def make_moves({rows, moves}, crane) do
    rows = rows |> Enum.map(fn x -> Enum.reject(x, fn y -> is_nil(y) end) end)

    case length(moves) do
      x when x > 0 -> make_move(rows, moves, crane)
      _ -> rows
    end
  end

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def make_move(rows, moves, crane) do
    x = List.first(moves)
    IO.puts("moving #{x.move} from row #{x.from} to row #{x.to}")

    from = Enum.at(rows, x.from - 1)
    move = Enum.take(from, x.move)
    to = Enum.at(rows, x.to - 1)

    move = if crane == "9000", do: Enum.reverse(move)
    new = List.replace_at(rows, x.to - 1, move ++ to)

    new =
      new
      |> List.replace_at(x.from - 1, Enum.drop(Enum.at(rows, x.from - 1), length(move)))

    make_moves({new, Enum.drop(moves, 1)}, crane)
  end
end

input = Solution.parse_input("input.txt")

solution_one =
  input
  |> Solution.make_moves("9000")
  |> Enum.map(fn x -> Enum.at(x, 0) end)
  |> Enum.join()

solution_two =
  input
  |> Solution.make_moves("9001")
  |> Enum.map(fn x -> Enum.at(x, 0) end)
  |> Enum.join()
