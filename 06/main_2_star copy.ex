data = File.read!("input_2_star.txt")

# Parse the input data into a matrix
matrix =
  data
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_charlist/1)

# Find the initial position of `^`
{start_x, start_y} =
  matrix
  |> Enum.with_index()
  |> Enum.reduce_while(nil, fn {row, idx}, _ ->
    case Enum.find_index(row, &(&1 == ?^)) do
      nil -> {:cont, nil}
      idy -> {:halt, {idx, idy}}
    end
  end)

# Get the matrix dimensions
num_rows = length(matrix)
num_columns = length(List.first(matrix))

# Navigation function
navigate = fn navigate_fun, matrix, x, y, direction, acc ->
  if x < 0 or x >= num_rows or y < 0 or y >= num_columns do
    false
  else
    {next_x, next_y} =
      case direction do
        :up -> {x - 1, y}
        :down -> {x + 1, y}
        :left -> {x, y - 1}
        :right -> {x, y + 1}
      end

    if next_x < 0 or next_x >= num_rows or next_y < 0 or next_y >= num_columns do
      false
    else
      next_value = Enum.at(Enum.at(matrix, next_x), next_y)

      if next_value != ?# do
        navigate_fun.(navigate_fun, matrix, next_x, next_y, direction, acc)
      else
        key = {direction, x, y}
        acc = Map.update(acc, key, 0, &(&1 + 1))

        cond do
          Map.get(acc, key) == 2 ->
            true

          true ->
            new_direction =
              case direction do
                :up -> :right
                :down -> :left
                :right -> :down
                :left -> :up
              end

            navigate_fun.(navigate_fun, matrix, x, y, new_direction, acc)
        end
      end
    end
  end
end

# Generate all possible matrices with one modified cell
matrices =
  for x <- 0..(num_rows - 1),
      y <- 0..(num_columns - 1),
      do:
        List.update_at(matrix, x, fn row ->
          List.update_at(row, y, fn cell ->
            if cell != ?^, do: ?#, else: cell
          end)
        end)

# Count the matrices where navigation loops
loop_count =
  matrices
  |> Enum.filter(fn new_matrix ->
    navigate.(navigate, new_matrix, start_x, start_y, :up, %{})
  end)
  |> length()

IO.inspect(loop_count)
