# 1 star
data = File.read!("input_1_star.txt")

matrix =
  data
  |> String.split("\n", trim: true)
  |> Enum.reduce([], fn values, rows ->
    List.insert_at(
      rows,
      -1,
      values
      |> String.to_charlist()
      |> Enum.reduce([], fn x, vs -> vs ++ [x] end)
    )
  end)

{start_x, start_y} =
  matrix
  |> Enum.with_index()
  |> Enum.reduce_while({0, 0}, fn {row, idx}, {start_x, start_y} ->
    row
    |> Enum.find_index(fn x -> x == ?^ end)
    |> (fn idy ->
          if idy == nil, do: {:cont, {0, 0}}, else: {:halt, {idx, idy}}
        end).()
  end)

num_rows = length(matrix)
num_columns = length(Enum.at(matrix, 0))

navigate = fn navigate_fun, matrix, x, y, direction, acc ->
  IO.inspect("x #{x} y #{y} direction #{direction} with acc #{length(Map.keys(acc))}\n")

  if x >= num_rows or x < 0 or y >= num_columns or y < 0 do
    {:done, acc}
  end

  acc = Map.put(acc, "#{x}_#{y}", 1)

  {next_x, next_y} =
    cond do
      direction == :up -> {x - 1, y}
      direction == :down -> {x + 1, y}
      direction == :left -> {x, y - 1}
      direction == :right -> {x, y + 1}
    end

  if next_x >= num_rows or next_x < 0 or next_y >= num_columns or next_y < 0 do
    {:done, acc}
  else
    next_value = Enum.at(Enum.at(matrix, next_x), next_y)

    if next_value != ?# do
      navigate_fun.(navigate_fun, matrix, next_x, next_y, direction, acc)
    else
      cond do
        direction == :up ->
          navigate_fun.(navigate_fun, matrix, next_x + 1, next_y + 1, :right, acc)

        direction == :down ->
          navigate_fun.(navigate_fun, matrix, next_x - 1, next_y - 1, :left, acc)

        direction == :right ->
          navigate_fun.(navigate_fun, matrix, next_x + 1, next_y - 1, :down, acc)

        direction == :left ->
          navigate_fun.(navigate_fun, matrix, next_x - 1, next_y + 1, :up, acc)
      end
    end
  end
end

# Start navigation
{_, result} = navigate.(navigate, matrix, start_x, start_y, :up, %{})

IO.inspect(length(Map.keys(result)))
