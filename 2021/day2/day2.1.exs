defmodule Movement do
  def move({x, y}, command) do
    [direction, stringNum] = String.split(command, " ")
    amount = String.to_integer(stringNum)

    case direction do
      "forward" -> {x + amount, y}
      "down" -> {x, y + amount}
      "up" -> {x, y - amount}
    end
  end
end

File.cwd!()
|> Path.join("input.txt")
|> File.read!()
|> String.split("\r\n", trim: true)
|> Enum.map(fn x -> Movement.move({0, 0}, x) end)
|> Enum.reduce(fn {a, b}, num -> {elem(num, 0) + a, elem(num, 1) + b} end)
|> IO.inspect()
|> Tuple.product()
|> IO.puts()

# |> Enum.map()
