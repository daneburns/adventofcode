File.cwd!()
|> Path.join("input.txt")
|> File.read!()
|> String.split("\r\n", trim: true)
|> Enum.map(&String.split(&1, " "))
|> Enum.map(fn [direction, amount] -> [String.to_atom(direction), String.to_integer(amount)] end)
|> Enum.reduce({0, 0, 0}, fn
  [:forward, amount], {a, b, c} -> {a + amount, b + c * amount, c}
  [:down, amount], {a, b, c} -> {a, b, c + amount}
  [:up, amount], {a, b, c} -> {a, b, c - amount}
end)
|> Tuple.delete_at(2)
|> Tuple.product()
|> IO.puts()
