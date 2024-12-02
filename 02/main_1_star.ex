# 1 star
data = File.read!("input_1_star.txt")

data
|> String.split("\n", trim: true)
|> Enum.map(fn row ->
  row
  |> String.split()
  |> Enum.map(&String.to_integer/1)
  |> Enum.chunk_every(2, 1, :discard)
  |> Enum.reduce_while(:not_init, fn [v1, v2], state ->
    cond do
      abs(v1 - v2) > 3 or abs(v1 - v2) < 1 ->
        {:halt, :wrong}

      state == :not_init ->
        new_state = if v1 < v2, do: :asc, else: :desc
        {:cont, new_state}

      state == :asc and v1 >= v2 ->
        {:halt, :wrong}

      state == :desc and
          v1 <= v2 ->
        {:halt, :wrong}

      true ->
        {:cont, state}
    end
  end)
end)
|> Enum.count(fn x -> x != :wrong end)
