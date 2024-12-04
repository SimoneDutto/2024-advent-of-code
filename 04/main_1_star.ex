# 1 star
data = File.read!("input_1_star.txt")

regex = ~r/(?=(XMAS|SAMX))/

matches_rows =
  Regex.scan(regex, data)
  |> Enum.count()

columns_data =
  data
  |> String.split("\n", trim: true)
  |> Enum.reduce(nil, fn row, acc ->
    row
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.reduce(acc || List.duplicate([], String.length(row)), fn {value, index}, acc ->
      List.update_at(acc, index, &(&1 ++ [value]))
    end)
  end)
  |> Enum.join("\n")

IO.inspect(columns_data)

matches_columns =
  Regex.scan(regex, columns_data)
  |> Enum.count()

sum =
  columns_data
  |> String.split("\n", trim: true)
  |> Enum.concat(String.split(data, "\n", trim: true))
  |> Enum.count()

diagonals_data_one_way =
  data
  |> String.split("\n", trim: true)
  |> Enum.with_index()
  |> Enum.reduce(nil, fn {row, idx_row}, acc ->
    row
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.reduce(acc || List.duplicate([], sum), fn {value, idx_col}, acc ->
      new_index =
        if idx_row - idx_col < 0,
          do: div(sum, 2) + abs(idx_row - idx_col),
          else: idx_row - idx_col

      List.update_at(acc, new_index, &(&1 ++ [value]))
    end)
  end)
  |> Enum.join("\n")

IO.inspect(diagonals_data_one_way)

matches_diagonals_one_way =
  Regex.scan(regex, diagonals_data_one_way)
  |> Enum.count()

diagonals_data_other_way =
  data
  |> String.split("\n", trim: true)
  |> Enum.map(fn x -> String.reverse(x) end)
  |> Enum.with_index()
  |> Enum.reduce(nil, fn {row, idx_row}, acc ->
    row
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.reduce(acc || List.duplicate([], sum), fn {value, idx_col}, acc ->
      new_index =
        if idx_row - idx_col < 0,
          do: div(sum, 2) + abs(idx_row - idx_col),
          else: idx_row - idx_col

      List.update_at(acc, new_index, &(&1 ++ [value]))
    end)
  end)
  |> Enum.join("\n")

IO.inspect(diagonals_data_other_way)

matches_diagonals_other_way =
  Regex.scan(regex, diagonals_data_other_way)
  |> Enum.count()

IO.inspect(
  matches_rows + matches_columns + matches_diagonals_one_way + matches_diagonals_other_way,
  label: "total"
)
