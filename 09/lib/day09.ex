defmodule Day09 do
  def input do
    data = File.read!("input_1_star.txt")

    {_, list, _} =
      data
      |> String.trim("\n")
      |> String.to_charlist()
      |> Enum.reduce({:file, [], 0}, fn x, {type, acc, idx} ->
        cond do
          type == :file ->
            {:empty, acc ++ [{:file, String.to_integer(<<x>>), idx}], idx + 1}

          type == :empty ->
            {:file, acc ++ [{:empty, String.to_integer(<<x>>), 0}], idx}
        end
      end)

    list
  end

  def star1 do
    list = input()

    {new_list, list} =
      list
      |> Enum.with_index()
      |> Enum.reduce({[], list}, fn {{type, size, idx}, i}, {new_list, list} ->
        cond do
          type == :file ->
            {new_list ++ [Enum.at(list, i)], list}

          type == :empty ->
            {size, updates} =
              list
              |> Enum.with_index()
              |> Enum.filter(fn {{type_el, size_el, idx_el}, index_in_list} ->
                size_el != 0 and index_in_list > i
              end)
              |> Enum.reverse()
              |> Enum.reduce_while({size, []}, fn {{type_el, size_el, idx_el}, index_in_list},
                                                  {size_to_fill, elems} ->
                cond do
                  type_el == :file ->
                    if size_el >= size_to_fill do
                      {:halt, {0, elems ++ [{index_in_list, size_to_fill, idx_el}]}}
                    else
                      {:cont,
                       {size_to_fill - size_el, elems ++ [{index_in_list, size_el, idx_el}]}}
                    end

                  true ->
                    {:cont, {size_to_fill, elems}}
                end
              end)

            {new_list, list} =
              updates
              |> Enum.reduce({new_list, list}, fn {index_in_list, size_el, idx_el},
                                                  {new_list, list} ->
                {
                  new_list ++ [{:file, size_el, idx_el}],
                  List.update_at(list, index_in_list, fn {t, s, i} -> {t, s - size_el, i} end)
                }
              end)

            {
              new_list ++ [{:empty, size, 0}],
              List.update_at(list, i, fn {t, _, i} -> {t, size, i} end)
            }
        end
      end)

    result =
      new_list
      |> Enum.filter(fn {type, size_el, idx_el} -> size_el != 0 or type == :empty end)
      |> Enum.map(fn
        {:file, num, val} -> String.duplicate(Integer.to_string(val), num)
        {:empty, num, _} -> String.duplicate(Integer.to_string(0), num)
      end)
      |> Enum.join("")
      |> IO.inspect()
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(0, fn {digit_str, idx}, acc ->
        acc + String.to_integer(digit_str) * idx
      end)

    IO.puts("Result: #{result}")
  end

  def star2 do
  end
end
