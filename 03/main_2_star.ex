data = File.read!("input_2_star.txt")

regex = ~r/(mul\((\d+),(\d+)\)|do\(\)|don't\(\))/

matches = Regex.scan(regex, data)

{sum, _} =
  Enum.reduce(matches, {0, true}, fn match, {a, enabled} ->
    case match do
      [_, _, num1, num2] ->
        num1 = String.to_integer(num1)
        num2 = String.to_integer(num2)

        if enabled do
          {a + num1 * num2, enabled}
        else
          {a, enabled}
        end

      ["do()", _] ->
        {a, true}

      ["don't()", _] ->
        {a, false}

      _ ->
        {a, enabled}
    end
  end)

IO.inspect(sum)
