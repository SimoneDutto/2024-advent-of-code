# 1 star
data = File.read!("input_2_star.txt")

regex = ~r/M.S.A.M.S|M.M.A.S.S|S.S.A.M.M|S.M.A.S.M/

flattened_list =
  data
  |> String.split("\n", trim: true)
  |> Enum.chunk_every(3, 1, :discard)
  |> Enum.map(fn rows ->
    rows
    |> Enum.reduce(List.duplicate("", String.length(Enum.at(rows, 0)) * 3), fn row, acc ->
      row
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {value, index}, acc ->
        acc
        |> List.update_at(index, &"#{&1}#{<<value>>}")
        |> List.update_at(index - 1, &"#{&1}#{<<value>>}")
        |> List.update_at(index + 1, &"#{&1}#{<<value>>}")
      end)
    end)
  end)
  |> List.flatten()

match_count =
  flattened_list
  |> IO.inspect()
  |> Enum.map(&Regex.match?(regex, &1))
  |> Enum.count(fn x -> x == true end)

IO.inspect(match_count)
