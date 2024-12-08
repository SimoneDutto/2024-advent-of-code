defmodule Day8 do
  def input do
    data = File.read!("input_1_star.txt")

    matrix =
      data
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    num_rows = length(matrix)
    num_columns = length(Enum.at(matrix, 0))

    antennas_map = matrix
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, idx}, map ->
        row
          |> Enum.with_index()
          |> Enum.reduce(map, fn {val, idy}, map ->
            if val != ?. do
              Map.update(map, val, [{idx, idy}], &(&1 ++ [{idx, idy}]))
            else
              map
            end
        end)
    end)

    {matrix, num_rows, num_columns, antennas_map}
  end

  def star1 do
    # 1 star
    {matrix, num_rows, num_columns, antennas_map} = input()

    antennas_map
    |> Enum.reduce(%{}, fn {key, positions}, acc ->
      IO.inspect(acc)
      # IO.gets("")
      Comb.combinations(positions, 2)
        |> Enum.to_list
        |> Enum.reduce(acc, fn [{v1x, v1y}, {v2x, v2y}], acc ->
          diff_x = v1x - v2x
          diff_y = v1y - v2y

          [
            {v1x + diff_x, v1y + diff_y},
            {v2x + diff_x, v2y + diff_y},
            {v1x - diff_x, v1y - diff_y},
            {v2x - diff_x, v2y - diff_y},
          ]
          |> Enum.reduce(acc, fn {idx, idy}, acc ->
            cond do
            idx < num_rows and idy < num_columns and idx >= 0 and idy >= 0 and Enum.at(Enum.at(matrix, idx), idy) != key ->
              Map.put(acc, "#{idx}_#{idy}", 1)
            true -> acc
            end
          end)
        end)
    end)
    |> Map.keys()
    |> IO.inspect()
    |> Enum.count()
    |> IO.inspect()
  end

  def star2 do
    {matrix, num_rows, num_columns, antennas_map} = input()

    antennas_map
    |> Enum.reduce(%{}, fn {key, positions}, acc ->
      Comb.combinations(positions, 2)
        |> Enum.to_list
        |> Enum.reduce(acc, fn [{v1x, v1y}, {v2x, v2y}], acc ->
          IO.inspect(acc)
          # IO.gets("")
          diff_x = v1x - v2x
          diff_y = v1y - v2y
          IO.inspect({v1x, v1y})
          IO.inspect({v2x, v2y})
          t_x = div(num_rows, diff_x)
          t_y = div(num_columns, diff_y)
          t = if t_x > t_y, do: t_x, else: t_y

          for i <- 1..(t+1), reduce: acc do
            acc ->
              [
                {v1x + i * diff_x, v1y + i * diff_y},
                {v2x + i * diff_x, v2y + i * diff_y},
                {v1x - i * diff_x, v1y - i * diff_y},
                {v2x - i * diff_x, v2y - i * diff_y}
              ]
            |> IO.inspect()
            |> Enum.reduce(acc, fn {idx, idy}, acc ->
              cond do
              idx < num_rows and idy < num_columns and idx >= 0 and idy >= 0 ->
                Map.put(acc, "#{idx}_#{idy}", 1)
              true -> acc
              end
            end)
          end
        end)
    end)
    |> Map.keys()
    |> IO.inspect()
    |> Enum.count()
    |> IO.inspect()
  end
end
