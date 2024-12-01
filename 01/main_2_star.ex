## 2 star
data = File.read!("input_2_star.txt")

{v1_list, v2_freq_map} =
  data
  |> String.split([" ", "\n", "\t"], trim: true)
  |> Enum.chunk_every(2)
  |> Enum.reduce({[], %{}}, fn [v1, v2], {v1_list, v2_freq_map} ->
    {[String.to_integer(v1) | v1_list],
     Map.update(v2_freq_map, String.to_integer(v2), 1, fn existing_value ->
       existing_value + 1
     end)}
  end)

v1_list
|> Enum.reduce(0, fn v1, acc ->
  acc + v1 * Map.get(v2_freq_map, v1, 0)
end)
|> IO.inspect()
