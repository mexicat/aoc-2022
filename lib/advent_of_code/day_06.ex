defmodule AdventOfCode.Day06 do
  def part1(input) do
    input |> parse_input() |> find_sequence()
  end

  def part2(input) do
    input |> parse_input() |> find_sequence_2()
  end

  def find_sequence(seq, n \\ 0)

  def find_sequence([a, b, c, d | _], n)
      when a != b and a != c and a != d and b != c and b != d and c != d,
      do: n + 4

  def find_sequence([_ | t], n), do: find_sequence(t, n + 1)

  # this would be faster if we matched on the function head like above,
  # but i don't want to write that for 14 numbers
  def find_sequence_2(seq, n \\ 0) do
    case seq |> Enum.take(14) |> MapSet.new() |> MapSet.size() do
      14 -> n + 14
      _ -> find_sequence_2(Enum.drop(seq, 1), n + 1)
    end
  end

  def parse_input(input) do
    input |> String.trim() |> String.to_charlist()
  end
end
