# 1 star
data = File.read!("input_1_star.txt")

regex = ~r/mul\((\d+),(\d+)\)/

matches = Regex.scan(regex, data)

sum =
  Enum.reduce(matches, 0, fn [_, num1, num2], a ->
    a + String.to_integer(num1) * String.to_integer(num2)
  end)

IO.inspect(sum)
