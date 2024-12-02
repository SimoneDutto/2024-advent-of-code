data = File.read!("input_2_star.txt")

first_run =
  data
  |> String.split("\n", trim: true)
  |> Enum.map(fn row ->
    row
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce_while({:not_init, :not_init, []}, fn [v1, v2], {state, wrong, l} ->
      {state, wrong, l} =
        if state == :not_init do
          if abs(v1 - v2) <= 3 and abs(v1 - v2) >= 1 do
            new_state = if v1 < v2, do: :asc, else: :desc
            {new_state, wrong, l ++ [v1]}
          else
            {state, :first_wrong, l}
          end
        else
          {state, wrong, l}
        end

      cond do
        wrong == :first_wrong ->
          {:cont, {state, wrong, l ++ [v2]}}

        abs(v1 - v2) > 3 or abs(v1 - v2) < 1 or
          (state == :asc and v1 >= v2) or
            (state == :desc and v1 <= v2) ->
          if wrong == :first_wrong do
            {:halt, {state, :wrong, l}}
          else
            {:cont, {state, :first_wrong, l}}
          end

        true ->
          {:cont, {state, wrong, l ++ [v2]}}
      end
    end)
  end)

count1 =
  first_run
  |> Enum.count(fn {_, x, _} -> x != :wrong and x != :first_wrong end)

IO.inspect(count1)

first_run
|> Enum.filter(fn {_, state, _} -> state == :first_wrong end)
|> IO.inspect(charlists: :as_lists)
|> Enum.count()
|> IO.inspect(charlists: :as_lists)

count2 =
  first_run
  |> Enum.filter(fn {_, state, _} -> state == :first_wrong end)
  |> Enum.map(fn {_, _, l} -> l end)
  |> Enum.map(fn row ->
    row
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce_while({:not_init, :not_init, []}, fn [v1, v2], {state, wrong, l} ->
      cond do
        abs(v1 - v2) > 3 or abs(v1 - v2) < 1 or
          (state == :asc and v1 >= v2) or
            (state == :desc and v1 <= v2) ->
          {:halt, {state, :wrong, l ++ [v2]}}

        state == :not_init ->
          new_state = if v1 < v2, do: :asc, else: :desc
          {:cont, {new_state, wrong, l ++ [v1, v2]}}

        true ->
          {:cont, {state, wrong, l ++ [v2]}}
      end
    end)
  end)
  |> IO.inspect(charlists: :as_lists)
  |> Enum.count(fn {_, x, _} -> x != :wrong end)

IO.inspect(count2)

IO.inspect(count1 + count2)
