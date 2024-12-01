data = File.read!("input.txt")

{v1_list, v2_list} =
  data
  |> String.split([" ", "\n", "\t"], trim: true)
  |> Enum.chunk_every(2)
  |> Enum.reduce({[], []}, fn [v1, v2], {v1_list, v2_list} ->
    {[String.to_integer(v1) | v1_list], [String.to_integer(v2) | v2_list]}
  end)

v1_list = Enum.sort(v1_list)
v2_list = Enum.sort(v2_list)

Enum.zip(v1_list, v2_list)
|> Enum.reduce(0, fn {v1, v2}, acc ->
  acc + abs(v2 - v1)
end)
|> IO.inspect()
