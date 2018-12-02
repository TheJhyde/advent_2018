defmodule Advent do
  def add_sum_to_list(n, []), do: [n]
  def add_sum_to_list(n, acc) do
    acc ++ [n + (List.last(acc))]
  end

  def find_repeat(sequence) do
    find_repeat(sequence, 9999999, 0)
  end

  def find_repeat([n | seq], place, repeat) do
    {new_place, new_repeat} = check_column(n, seq, place, repeat, 0)
    if new_place < place do
      find_repeat(seq, new_place, new_repeat)
    else
      find_repeat(seq, place, repeat)
    end
  end

  def find_repeat([], _, repeat) do
    repeat
  end

  def check_column(_n1, [], place, repeat, _index), do: {place, repeat}
  def check_column(_n1, [_n2], place, repeat, _index), do: {place, repeat}

  def check_column(n1, [n2 | seq], place, repeat, index) do
    sum = List.last(seq)
    diff = abs(n1 - n2)
    case rem(diff, sum) do
      0 ->
        new_place = diff/sum + index
        if new_place < place do
          new_repeat = if n1 > n2, do: n1, else: n2
          check_column(n1, seq, new_place, new_repeat, index+1)
        else
          check_column(n1, seq, place, repeat, index+1)
        end
      _ ->
        check_column(n1, seq, place, repeat, index+1)
    end
  end
end

# content = "+3, +3, +4, -2, -4"
# sums = String.split(content, ", ")
{:ok, content} = File.read("day1_input.txt")
sums = String.split(content, "\n")
|> Enum.map(fn n -> String.to_integer(n) end)
|> Enum.reduce([], fn n, acc -> Advent.add_sum_to_list(n, acc) end)

IO.puts List.last(sums)

repeat = Advent.find_repeat(sums)
IO.puts repeat