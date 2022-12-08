defmodule Solution do
  def parse_input(path) do
    File.read!(path)
    |> String.split("\n")
    |> Enum.reject(fn x -> x == "" end)
  end

  def get_dir_sizes({dir, files}, filetree) do
    children =
      Enum.filter(filetree, fn {x, y} -> String.contains?(x, dir) end)
      |> Enum.map(fn {x, y} ->
        Enum.map(y, fn z -> String.split(z, " ") |> hd() |> Integer.parse() |> elem(0) end)
        |> Enum.sum()
      end)

    %{dir => Enum.sum(children)}
  end

  def get_at_most(sizes) do
    Enum.map(sizes, fn x ->
      Enum.filter(sizes, fn y ->
        first_val = Map.values(y) |> hd()
        second_val = Map.values(x) |> hd()

        total =
          case first_val do
            first_val when first_val == second_val -> false
            _ -> first_val + second_val
          end

        total < 100_000
      end)
    end)
    |> List.flatten()
  end

  def sum_dirs(tuple_list) do
    Enum.map(tuple_list, fn x -> Map.values(x) end)
    |> List.flatten()
    |> Enum.sum()
  end

  def parse_dirs([], currentpath, fs) do
    fs
  end

  def parse_dirs(commands, currentpath, fs) do
    [command | rest] = commands

    case command do
      "$ cd" <> " " <> ".." ->
        currentpath = String.split(currentpath, "/", trim: true)

        currentpath = Enum.slice(currentpath, 0..(length(currentpath) - 2))

        currentpath =
          case currentpath do
            x when length(x) == 1 ->
              ""

            x ->
              Enum.join(x)
          end

        currentpath = "/" <> currentpath

        parse_dirs(rest, currentpath, fs)

      "$ cd" <> " " <> "/" ->
        parse_dirs(rest, "/", %{"/" => []})

      "$ cd" <> " " <> dir ->
        parse_dirs(rest, "#{currentpath}#{dir}/", fs)

      "$ ls" ->
        contents = Enum.take_while(rest, fn x -> hd(String.split(x)) !== "$" end)
        contents_length = Enum.count(contents)

        new_fs =
          Enum.map(contents, fn x ->
            case x do
              "dir " <> dirname -> Map.merge(fs, %{"#{currentpath}#{dirname}/" => []})
              x -> false
            end
          end)
          |> Enum.filter(fn x -> x end)
          |> List.flatten()
          |> Enum.reduce(fs, fn x, acc -> Map.merge(x, acc) end)

        just_files = Enum.filter(contents, fn x -> hd(String.split(x, " ")) != "dir" end)

        new_fs = new_fs |> Map.put(currentpath, just_files)
        change_dir = Enum.at(rest, contents_length)

        parse_dirs(
          Enum.slice(rest, contents_length..(length(rest) - 1)),
          currentpath,
          new_fs
        )
    end
  end
end

input = Solution.parse_input("input.txt")
test_input = Solution.parse_input("test_input.txt")

file_tree = input |> Solution.parse_dirs("", %{})

solution_one =
  file_tree
  |> Enum.map(fn x -> Solution.get_dir_sizes(x, file_tree) end)
  |> Solution.get_at_most()
  |> IO.inspect()
  |> Solution.sum_dirs()
  |> IO.inspect()
