# 1 star
data = File.read!("input_1_star.txt")

data
|> String.split("\n", trim: true)
|> Enum.map(fn row ->
  total =
    row
    |> String.split(":")
    |> Enum.at(0)
    |> String.to_integer()

  numbers =
    row
    |> String.split(":")
    |> Enum.at(1)
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer(&1))

  explore = fn explore_fun, numbers, idx, acc ->
    # IO.inspect("idx #{idx} acc: #{acc}")
    # IO.gets("")

    cond do
      acc > total ->
        false

      idx == length(numbers) ->
        if acc == total, do: true, else: false

      true ->
        value = Enum.at(numbers, idx)
        res = explore_fun.(explore_fun, numbers, idx + 1, acc + value)

        if res == true do
          true
        else
          res = explore_fun.(explore_fun, numbers, idx + 1, acc * value)

          if res == true do
            true
          else
            String.to_integer("#{acc}#{value}")
            explore_fun.(explore_fun, numbers, idx + 1, String.to_integer("#{acc}#{value}"))
          end
        end
    end
  end

  if explore.(explore, numbers, 1, Enum.at(numbers, 0)) == true do
    total
  else
    0
  end
end)
|> Enum.sum()
|> IO.inspect()
