defmodule Solution do
  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
  end

  def replace_string_digits(code) do
    digits = [
      one: "1",
      two: "2",
      three: "3",
      four: "4",
      five: "5",
      six: "6",
      seven: "7",
      eight: "8",
      nine: "9"
    ]

    keys = Enum.map(digits, &elem(&1, 0)) |> Enum.map(fn x -> Atom.to_string(x) end)

    pattern = ~r(one|two|three|four|five|six|seven|eight|nine)

    first =
      String.replace(
        code,
        pattern,
        fn x ->
          Keyword.fetch!(digits, x |> String.to_existing_atom())
        end,
        global: false
      )
      |> String.split("", trim: true)
      |> Enum.filter(fn x -> Solution.is_parseable_int?(x) end)
      |> List.first()

    reversed_patterns = Enum.map(keys, fn x -> String.reverse(x) end)
    reversed_code = String.reverse(code)

    last =
      String.replace(reversed_code, reversed_patterns, fn x -> replace_back_string(x) end,
        global: false
      )
      |> String.split("", trim: true)
      |> Enum.filter(fn x -> Solution.is_parseable_int?(x) end)
      |> List.first()

    (first <> last) |> String.to_integer()
  end

  def replace_back_string(str) do
    case str do
      "eno" -> "1"
      "owt" -> "2"
      "eerht" -> "3"
      "ruof" -> "4"
      "evif" -> "5"
      "xis" -> "6"
      "neves" -> "7"
      "thgie" -> "8"
      "enin" -> "9"
    end
  end

  def is_parseable_int?(string), do: if(Integer.parse(string) == :error, do: false, else: true)

  def get_cab_value(string) do
    string = String.split(string, "", trim: true)

    nums = Enum.filter(string, fn x -> if Integer.parse(x) == :error, do: false, else: true end)

    first = List.first(nums)
    last = List.last(nums)

    (first <> last)
    |> String.to_integer()
  end
end

one =
  Solution.parse_input("./input.txt")
  |> Enum.map(fn x -> Solution.get_cab_value(x) end)
  |> Enum.sum()

two =
  Solution.parse_input("./input.txt")
  |> Enum.map(fn x -> Solution.replace_string_digits(x) end)
  |> Enum.sum()
