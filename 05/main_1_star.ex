# 1 star
data = File.read!("input_1_star.txt")

[map, checks] =
  data
  |> String.split("\n\n")

{maponwards, mapbackwords} =
  map
  |> String.split("\n", discard: true)
  |> Enum.reduce({%{}, %{}}, fn row, {maponwards, mapbackwords} ->
    [v1, v2] = String.split(row, "|", discard: true)

    {Map.update(maponwards, v1, [v2], fn x -> x ++ [v2] end),
     Map.update(mapbackwords, v2, [v1], fn x -> x ++ [v1] end)}
  end)

# IO.inspect(maponwards)
# IO.inspect(mapbackwords)

checks
|> String.split("\n", trim: true)
|> Enum.map(fn row ->
  list = String.split(row, ",", trim: true)

  couples_array =
    for i <- 0..(length(list) - 2),
        j <- (i + 1)..(length(list) - 1),
        do: {Enum.at(list, i), Enum.at(list, j)}

  couples_array
  |> Enum.map(fn {v1, v2} ->
    Map.get(maponwards, v1, [])
    |> Enum.find(-1, fn x -> x == v2 end)
  end)
  |> Enum.all?(fn x -> x != -1 end)
  |> (fn all_found ->
        if all_found, do: Enum.at(list, div(length(list), 2)), else: "0"
      end).()
end)
|> Enum.map(&String.to_integer(&1))
|> Enum.sum()
|> IO.inspect()
