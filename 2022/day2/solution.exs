defmodule Game do
  def parse_input(input) do
    File.read!(input)
    |> String.split("\n")
    |> Enum.map(fn pair ->
      String.split(pair, " ")
    end)
    |> Enum.reject(fn x -> x == [""] end)
  end

  def play_game(x) do
    [x, y] = x

    x =
      case x do
        "A" -> 1
        "B" -> 2
        "C" -> 3
        _ -> IO.puts("error: char not found")
      end

    y =
      case y do
        "X" -> 1
        "Y" -> 2
        "Z" -> 3
        _ -> IO.puts("error: char not found")
      end

    case {x, y} do
      x when elem(x, 0) == elem(x, 1) ->
        {elem(x, 0) + 3, elem(x, 1) + 3}

      {1, 2} ->
        {x, y + 6}

      {1, 3} ->
        {x + 6, y}

      {2, 1} ->
        {x + 6, y}

      {2, 3} ->
        {x, y + 6}

      {3, 1} ->
        {x, y + 6}

      {3, 2} ->
        {x + 6, y}
    end
  end

  def play_second_game(x) do
    [x, y] = x

    case y do
      "X" ->
        # lose
        case x do
          "A" -> ["A", "Z"]
          "B" -> ["B", "X"]
          "C" -> ["C", "Y"]
        end

      # draw
      "Y" ->
        case x do
          "A" -> ["A", "X"]
          "B" -> ["B", "Y"]
          "C" -> ["C", "Z"]
        end

      # win
      "Z" ->
        case x do
          "A" -> ["A", "Y"]
          "B" -> ["B", "Z"]
          "C" -> ["C", "X"]
        end
    end
  end
end

input = Game.parse_input("input.txt")

solution_one =
  input
  |> Enum.map(fn x -> Game.play_game(x) end)
  |> Enum.reduce(%{player_one: 0, player_two: 0}, fn {x, y}, acc ->
    %{player_one: acc.player_one + x, player_two: acc.player_two + y}
  end)

solution_two =
  input
  |> Enum.map(fn x -> Game.play_second_game(x) end)
  |> Enum.map(fn x -> Game.play_game(x) end)
  |> Enum.reduce(%{player_one: 0, player_two: 0}, fn {x, y}, acc ->
    %{player_one: acc.player_one + x, player_two: acc.player_two + y}
  end)
